(defsystem "cl-useful-rabish-test"
  :author "Tomoaki Nakajima"
  :license "MIT License"
  :pathname "tests/"
  :depends-on ("cl-useful-rabish-test/rhpds-info"
               "cl-useful-rabish-test/dockerhub-count")
  :description "Test system for cl-useful-rabish"
  :class :package-inferred-system
  :perform (test-op (op c) (symbol-call :rove :run c)))
