;;; auto-closing-tag-test.el --- Tests for auto-closing-tag

(require 'auto-closing-tag)

(ert-deftest find-tag-beg-pos/valid-tag-at-beginning ()
  "Should return the tag position."
  (should (equal (find-tag-beg-pos "<div>") 0)))

(ert-deftest find-tag-beg-pos/valid-tag-anywhere ()
  "Should return the tag position."
  (should (equal (find-tag-beg-pos "012345<div>") 6)))

(ert-deftest find-tag-beg-pos/no-tag ()
  "Should return nil when the tag doesn't have a tag."
  (should (equal (find-tag-beg-pos "no tag") nil)))

(ert-deftest find-tag-value-beg-pos/valid-tag-at-beginning ()
  "Should return the tag position."
  (with-temp-buffer
    (insert "<div>")
  (should (equal (find-tag-value-beg-pos) 1))))

(ert-deftest find-tag-value-beg-pos/valid-tag-anywhere ()
  "Should return the tag position."
  (with-temp-buffer
    (insert  "012345<div>")
    (should (equal (find-tag-value-beg-pos) 7))))

(ert-deftest find-tag-value-beg-pos/cursor-position-is-unchanged ()
  "Should not change cursor position."
  (with-temp-buffer
      (insert  "012345<div>")
      (let ((initial-column (current-column)))
      (find-tag-value-beg-pos)
      (should (equal (current-column) initial-column)))))

(ert-deftest find-tag-value-beg-pos/no-tag-on-this-line ()
  "Should return nil when there is not tag on the current line."
  (with-temp-buffer
    (insert  "012345<div>\n")
    (insert "no tag")
    (should (equal (find-tag-value-beg-pos) nil))))

(ert-deftest find-tag-value-beg-pos/no-tag ()
  "Should return nil when the tag doesn't have a tag."
  (with-temp-buffer
    (insert "no tag")
  (should (equal (find-tag-value-beg-pos) nil))))

(ert-deftest find-tag-value-end-pos/tag-end-line ()
  "Should return valid pos even when tag end the line."
  (with-temp-buffer
    (insert "<tag")
    (should (equal (find-tag-value-end-pos 1) 3))))

(ert-deftest find-tag-value-end-pos/space-delimiter ()
  "Should return end position when there is a whitespace."
  (with-temp-buffer
    (insert "<tag not a tag value")
    (should (equal (find-tag-value-end-pos 1) 3))))

(ert-deftest find-tag-value-end-pos/space-delimiter ()
  "Should not change cursor position."
  (with-temp-buffer
  (insert  "012345<div yadiyadi yada")
  (let ((initial-column (current-column)))
    (find-tag-value-end-pos 7)
    (should (equal (current-column) initial-column)))))

(ert-deftest get-tag-value/with-props ()
  "Should return tag value."
  (with-temp-buffer
    (insert "<div className={className}")
    (should (equal (get-tag-value) "div"))))

(ert-deftest get-tag-value/no-props ()
  "Should return tag value."
  (with-temp-buffer
    (insert "<div")
    (should (equal (get-tag-value) "div"))))

(ert-deftest get-tag-value/no-tag ()
  "Should return nil."
  (with-temp-buffer
    (insert "no tag")
    (should (equal (get-tag-value) nil))))


(ert-deftest auto-close-tag/no-props ()
  "Should auto close tag."
  (with-temp-buffer
    (insert "<div")
    (auto-close-tag)
    (should (equal (thing-at-point 'line t) "<div></div>"))))

(ert-deftest auto-close-tag/one-props ()
  "Should auto close tag."
  (with-temp-buffer
    (insert "<div props={myProps}")
    (auto-close-tag)
    (should (equal (thing-at-point 'line t) "<div props={myProps}></div>"))))

;;; auto-closing-tag-test.el ends here
