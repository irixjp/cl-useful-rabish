(defpackage cl-useful-rabish/rhpds-info
  (:use :cl)
  (:import-from :cl-ppcre)
  (:import-from :dexador)
  (:import-from :plump)
  (:import-from :clss)
  (:export :make-ansible-inventory
           :students-info-list))

(in-package :cl-useful-rabish/rhpds-info)

(defun node-text (node)
  "retrive text data from elements"
  (let ((text-list nil))
    (plump:traverse node
                    (lambda (node) (push (plump:text node) text-list))
                    :test #'plump:text-node-p)
    (apply #'concatenate 'string (nreverse text-list))))

(defun get-and-parse-rhpds-page (url)
  (plump:parse (dex:get url)))

(defun get-stundents-info (data)
  (coerce (clss:select ".student_logins" data) 'list))

(defun select-element-from-student-info (data selector)
  (aref (clss:select selector data) 0))

(defun get-ssh-info (student)
  (let* ((ssh (node-text (select-element-from-student-info student "#control_node")))
         (name
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "username:\\n +([a-zA-Z]+[0-9]+)" ssh)
            (aref r 0)))
         (password
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "password:\\n +([a-zA-Z0-9]+)" ssh)
            (aref r 0)))
         (ip_addr
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "IP Address:\\n +([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)" ssh)
            (aref r 0))))
    (list :ssh-name name :ssh-password password :ssh-ip-addr ip_addr)))

(defun get-tower-info (student)
  (let* ((tower (node-text (select-element-from-student-info student "#tower_info")))
         (tower-name
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "username:\\n +([a-zA-Z0-9]+)" tower)
            (aref r 0)))
         (tower-password
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "password:\\n +([a-zA-Z0-9]+)" tower)
            (aref r 0)))
         (tower-url
          (multiple-value-bind (q r)
              (ppcre:scan-to-strings "UI link:\\n((http|https)://[a-zA-Z0-9./?%&=]+)" tower)
            (aref r 0))))
    (list :tower-name tower-name :tower-password tower-password :tower-url tower-url)))

(defun students-info-list (url)
  (let* ((data (get-stundents-info (get-and-parse-rhpds-page url)))
         (ssh (mapcar #'get-ssh-info data))
         (tower (mapcar #'get-tower-info data)))
    (loop for i in ssh
          for j in tower
          collect (concatenate 'list i j))))

(defun make-ansible-inventory (list)
  (loop :for i :in list
     :do
       (format t "~A ansible_user=~A ansible_password=~A tower_url=~A tower_user=~A tower_password=~A~%"
               (getf i :ssh-ip-addr)
               (getf i :ssh-name)
               (getf i :ssh-password)
               (getf i :tower-url)
               (getf i :tower-name)
               (getf i :tower-password))))
