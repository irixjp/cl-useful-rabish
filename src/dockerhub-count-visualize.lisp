(defpackage cl-useful-rabish/dockerhub-count-visualize
  (:use :cl)
  (:import-from :eazy-gnuplot)
  (:import-from :cl-useful-rabish/dockerhub-count-db :show-count-data)
  (:export :make-graph-image))
(in-package :cl-useful-rabish/dockerhub-count-visualize)

(defun output-graph (data image-name graph-name)
  (eazy-gnuplot:with-plots (*standard-output* :debug nil)
    (eazy-gnuplot:gp-setup :xdata :time
                           :timefmt "%Y-%m-%d %H:%M:%S"
                           :format '(:x "%y-%m")
                           :xtics (* 60 60 24 7 4)
                           :xlabel '(:font "Times New Roman, 12")
                           :ylabel '(:font "Times New Roman, 12")
                           :output image-name
                           :key '(:bottom :right :font "Times New Roman, 12"))
    ;;(format t "~%unset key")
    (eazy-gnuplot:plot (lambda () (format t "~&~{~{~A ~A~%~}~}" data))
                       :using '(1 3)
                       :title graph-name
                       :with '(:linespoint :pt 7))))

(defun make-graph-image (image-name db-name png-name)
  (output-graph (show-count-data db-name image-name)
                png-name
                image-name))
