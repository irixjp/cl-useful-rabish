(defpackage cl-useful-rabish/dockerhub-count
  (:use :cl)
  (:import-from :quri)
  (:import-from :dexador)
  (:import-from :jonathan)
  (:import-from :cl-ppcre)
  (:documentation "Show container image infomation that is gotten from docekrhub."))
(in-package :cl-useful-rabish/dockerhub-count)

(defparameter *docker-hub-api* "https://registry.hub.docker.com/v2/repositories/")

(defun make-image-path (image)
  (if (ppcre:scan "[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+" image)
      image
      (concatenate 'string "library/" image)))

(defun get-image-info (image key)
  (let* ((url (quri:make-uri :defaults
                             (concatenate 'string
                                          *docker-hub-api*
                                          (make-image-path image)
                                          "/")))
         (data (getf (jonathan:parse (dex:get url)) (intern key :keyword))))
    data))

(defun get-image-pull-count (image)
  (get-image-info image "pull_count"))

(defun get-tags-list (image)
  (let* ((url (quri:make-uri :defaults
                             (concatenate 'string
                                          *docker-hub-api*
                                          (make-image-path image)
                                          "/tags/")))
         (data (mapcar #'(lambda (tag-info) (getf tag-info :|name|))
                       (getf (jonathan:parse (dex:get url)) :|results|))))
    data))
