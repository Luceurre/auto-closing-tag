;;; auto-closing-tag.el --- automatically create matching tag -*- lexical-binding: t -*-

;; Author: Pierre Glandon
;; Maintainer: Pierre Glandon
;; Version: 0.0.1
;; Package-Requires: (dependencies)
;; Homepage: homepage
;; Keywords: keywords


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; commentary

;;; Code:

(require 's)

(defun find-tag-beg-pos (text)
  "Return tag beginning position in TEXT if a tag exists.
Return nil otherwise."
  (s-index-of "<" text))

(defun auto-close-tag--find-tag-value-beg-pos ()
  "Return tag value beginning position in current buffer if a tag exists.
Return nil otherwise."
  (if (or (= (current-column) 0) (eq (char-before) ?\\))
      nil
    (if (eq (char-before) ?<)
        (current-column)
      (progn
        (backward-char)
             (find-tag-value-beg-pos)))))

(defun find-tag-value-beg-pos ()
  "Return tag value beginning position in current buffer if a tag exists.
Return nil otherwise."
  (save-excursion (auto-close-tag--find-tag-value-beg-pos))
  )

(defun auto-close-tag--find-tag-value-end-pos ()
  "Return tag value end position in the current buffer."
  (if (equal (point) (line-end-position))
        (- (current-column) 1)
    (if (or (eq (char-after) ?\s) (eq (char-after) ?>))
        (- (current-column) 1)
      (progn
        (forward-char)
        (auto-close-tag--find-tag-value-end-pos))))
  )
(defun find-tag-value-end-pos (tag-value-beg-pos)
  "Return tag value end position in the current buffer."
  (save-excursion
    (move-to-column tag-value-beg-pos)
    (auto-close-tag--find-tag-value-end-pos))
  )

(defun get-tag-value ()
  "Return tag value if tag exists on current line."
  (let* ((line (thing-at-point 'line t)) (line-length (length line)) (beg-tag-pos (find-tag-value-beg-pos)) (end-tag-pos (and beg-tag-pos (find-tag-value-end-pos beg-tag-pos))))
    (when beg-tag-pos
    (substring line beg-tag-pos (+ 1 end-tag-pos)))))

(defun auto-close-tag ()
  "Autoclose tag at point."
  (interactive)
  (save-excursion
  (let* ((tag-value (get-tag-value))
        (closing-tag (s-concat (or (and (equal (char-after) ?>) (and (progn (forward-char) t) "")) ">") "</" tag-value ">")))
      (if tag-value
          (insert closing-tag)
        (insert ">")))
  )
  (forward-char)
  )

(setq auto-close-tag-keymap (make-sparse-keymap))
(define-key auto-close-tag-keymap ">" 'auto-close-tag) 

(define-minor-mode auto-close-tag-mode
  "When auto-close-tag-mode is enabled, pressing > will try to find closest XML tag and close it."
  :lighter ">"
  :keymap auto-close-tag-keymap)
(provide 'auto-closing-tag)

;;; auto-closing-tag.el ends here
