;;; emacs-python-keys.el --- Hack the -/_ key to dwim unshifted (almost) all the time

;; Copyright (C) 2012 Anthony Lander <anthony.lander@gmail.com>

;; Authors: Anthony Lander
;; Created: 2012-03-24
;; Version: 0.1
;; Keywords: python dwim

;; This file is not (yet) part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This code tries to make it a bit easier to type variable_names_like_this in
;; python mode. It does this by looking at the character before you type '-' to
;; decide whether you really want to insert a minus '-' or an underscore '_'.
;; You can always get the alternative choice with shift-minus.

;;; Code:

(defun my-python-minus-or-underscore-p ()
  "Decide whether it would be more appropriate to insert a minus or an underscore. 
Return t for minus, nil for underscore."
  (let ((previous (char-to-string (preceding-char))))
    (cond
      ((bolp) t)                         ; begining of line means probably -
      ((string-match "\\s-" previous) t) ; - after a whitespace
      ((string-match "[\(\[\]\)=" previous) t) ; - after paren, bracket or =
      ((string-match "\\W" previous) t) ; - after a word character (probably in a variable name)
      ((string-match "\\w" previous) nil) ; _ after a non-word character
      (t t))))

(defun my-python-minus-key ()
  "Insert a minus or underscore as appropriate to make it easy to type variable_names_like_this in Python."
  (interactive)
  (if (my-python-minus-or-underscore-p)
      (insert ?-)
      (insert ?_)))

(defun my-python-underscore-key ()
  "Do the opposite of my-python-minus-key - that is insert a minus if it would insert an underscore and vv."
  (interactive)
  (if (my-python-minus-or-underscore-p)
      (insert ?_)
      (insert ?-)))

(add-hook 'python-mode-hook '(lambda () 
                              (define-key python-mode-map (kbd "-") 'my-python-minus-key)
                              (define-key python-mode-map (kbd "_") 'my-python-underscore-key)))

(provide 'emacs-python-keys)
