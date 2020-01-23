(defpackage cl-useful-rabish-test/rhpds-info
  (:use :cl
        :cl-useful-rabish/rhpds-info
        :rove))
(in-package :cl-useful-rabish-test/rhpds-info)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-useful-rabish)' in your Lisp.

(deftest test-target-rhpds-info
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
