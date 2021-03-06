(defpackage cl-useful-rabish/dockerhub-count-db
  (:use :cl)
  (:import-from :cl-dbi)
  (:import-from :cl-useful-rabish/dockerhub-count :get-image-pull-count)
  (:export :init-db :insert-count-data :show-count-data)
  (:documentation "Show container image infomation that is gotten from docekrhub."))
(in-package :cl-useful-rabish/dockerhub-count-db)

(defvar *db-name* #p"dockerhub.db")
(defvar *table-name* "dockerhub")

(defun fetch-db (conn sql)
  (dbi:fetch-all (dbi:execute (dbi:prepare conn sql))))

;; (defun create-db (path)
;;   (uiop:file-exists-p path)
;;   (uiop:run-program (concatenate 'string "echo  \".open " path "\" | sqlite3")))

(defun init-db (path)
  (dbi:with-connection (conn :sqlite3 :database-name path)
    (let* ((query (fetch-db conn "select name from sqlite_master where type='table';"))
           (ret (find *table-name*
                      (mapcar (lambda (table) (getf table :|name|)) query)
                      :test #'string=)))
      (unless ret
        (dbi:do-sql conn
          (format nil "CREATE TABLE ~A (date, name, count);" *table-name*))))
    (fetch-db conn "select name from sqlite_master where type='table';")))

(defun drop-db (db-path)
  (dbi:with-connection (conn :sqlite3 :database-name db-path)
    (dbi:do-sql conn (format nil "DROP TABLE ~A" *table-name*))))

(defun insert-count-data (db-path image)
  (let ((data (get-image-pull-count image)))
    (dbi:with-connection (conn :sqlite3 :database-name db-path)
      (dbi:do-sql conn
        (format nil "INSERT INTO ~A values(datetime('now', 'localtime'), '~A', '~A');"
                *table-name* image data)))))

(defun show-all-count-data (db-path)
  (dbi:with-connection (conn :sqlite3 :database-name db-path)
    (fetch-db conn "select * from dockerhub;")))

(defun show-count-data (db-path name)
  (dbi:with-connection (conn :sqlite3 :database-name db-path)
    (let ((data
           (fetch-db conn
                     (format nil "SELECT date, count FROM ~A where name = '~A';"
                             *table-name*
                             name))))
      (loop :for i :in data
         :collect (list (getf i :|date|)
                        (getf i :|count|))))))

;; The below is for data migration
;; (defvar *data* nil)
;; (defun load-text (file)
;;   (with-open-file (in file)
;;     (with-standard-io-syntax
;;       (setf *data* (read in)))))
;; (defun load-to-db (data)
;;   (dbi:with-connection (conn :sqlite3 :database-name *db-name*)
;;     (loop :for i :in data
;;        :do (dbi:do-sql conn
;;              (format nil "INSERT INTO ~A values('~A', '~A', '~A');"
;;                      *table-name*
;;                      (concatenate 'string (first i) " " (second i))
;;                      (concatenate 'string (third i) "/" (fourth i))
;;                      (fifth i))))))


