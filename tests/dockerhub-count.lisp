(defpackage cl-useful-rabish-test/dockerhub-count
  (:use :cl
        :cl-useful-rabish/dockerhub-count
        :rove))
(in-package :cl-useful-rabish-test/dockerhub-count)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-useful-rabish)' in your Lisp.

(deftest test-target-dockerhub-count
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
