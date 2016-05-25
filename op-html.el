;;; op-html.el --- custom html export backend for org-page. -*- lexical-binding: t -*-

;; Copyright (C) 2016 Sergei Maximov

;; Author: Sergei Maximov (smaximov) <s.b.maximov@gmail.com>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file defines a custom org-export backend derived from the HTML backend.

;;; Code:

(require 'ox)

;;; TODO: write tests

;; FIXME: provide a proper format string
(defconst op/datetime-format "%Y-%m-%dT%H:%M:%S.%3NZ"
  "A format string to represent UTC time conforming to RFC 3339.")

;; TODO: allow to override using locale-specific settings
(defconst op/default-date-format "%d.%m.%Y")

(defun op/html-timestamp (timestamp contents info)
  "Transcode a TIMESTAMP object from Org to HTML.
CONTENTS is nil.  INFO is a plist used as a communication channel."
  (ignore contents info)
  (let ((datetime (org-timestamp-format timestamp op/datetime-format nil t))
        (date (org-timestamp-format timestamp op/default-date-format nil t)))
    (format "<time datetime=\"%s\">%s</time>" datetime date)))

(org-export-define-derived-backend 'op/html 'html
  :translate-alist '((timestamp . op/html-timestamp)))

(provide 'op-html)
;;; op-html.el ends here
