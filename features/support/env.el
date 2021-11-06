(require 'f)

(defvar auto-closing-tag-support-path
  (f-dirname load-file-name))

(defvar auto-closing-tag-features-path
  (f-parent auto-closing-tag-support-path))

(defvar auto-closing-tag-root-path
  (f-parent auto-closing-tag-features-path))

(add-to-list 'load-path auto-closing-tag-root-path)

;; Ensure that we don't load old byte-compiled versions
(let ((load-prefer-newer t))
  (require 'auto-closing-tag)
  (require 'espuds)
  (require 'ert))

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
