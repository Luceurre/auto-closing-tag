;;; test-helper.el --- Helpers for auto-closing-tag-test.el

(defmacro with-sandbox (text &rest body)
  "Maybe I forgot the DOSCTRING ?"
  `(let ((default-directory "nothing"))
     (with-temp-buffer
     (progn ,@body))))
;;; test-helper.el ends here
