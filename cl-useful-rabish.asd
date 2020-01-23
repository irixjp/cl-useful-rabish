(defsystem "cl-useful-rabish"
  :version "0.1.0"
  :author "Tomoaki Nakajima"
  :license "MIT License"
  :pathname "src/"
  :depends-on ("cl-useful-rabish/rhpds-info"
               "cl-useful-rabish/dockerhub-count")
  :description "Personal tools for my work"
  :class :package-inferred-system
  :in-order-to ((test-op (test-op "cl-useful-rabish-test"))))
