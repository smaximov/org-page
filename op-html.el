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

(require 'dash)
(require 'ox)

;; FIXME: provide a proper format string
(defconst op/datetime-format "%Y-%m-%dT%H:%M:%S.%3NZ"
  "A format string to represent UTC time conforming to RFC 3339.")

(defconst op/default-date-format "%Y-%m-%d")

(defun op/get-locale (plist)
  "Get locale information from PLIST."
  (plist-get plist :locale))

(defun op/get-date-format (locale)
  "Get a date format specific to the LOCALE."
  (plist-get locale :date-format))

(defun op/read-org-metadata ()
  "Read the current buffer's metadata."
  (org-export--get-inbuffer-options 'op/html))

(defun op/metadata-get (key meta)
  "Get a value denoted by KEY from metadata META."
  (plist-get meta key))

(defun op/get-tags (meta)
  "Read a list of tags from metadata META."
  (-when-let (tags (op/metadata-get :tags meta))
    (save-match-data
      (split-string tags "[ ,]+" t))))

(defun op/get-uri (meta)
  "Get a uri slug from metadata META."
  (op/metadata-get :uri meta))

(defun op/draft? (meta)
  "Determine if an Org entry is a draft using its metadata META."
  (-when-let (draft (op/metadata-get :draft meta))
    (not (equal draft "nil"))))

(defun op/get-keywords (meta)
  "Read a list of keywords from metadata META."
  (-when-let (keywords (op/metadata-get :keywords meta))
    (save-match-data
     (split-string keywords "[ ,]+" t))))

(defun op/html-timestamp (timestamp contents info)
  "Transcode a TIMESTAMP object from Org to HTML.
CONTENTS is nil.  INFO is a plist used as a communication channel."
  (ignore contents info)
  (let* ((datetime (org-timestamp-format timestamp op/datetime-format nil t))
         (date-format (or (op/get-date-format (op/get-locale info))
                          op/default-date-format))
         (date (org-timestamp-format timestamp date-format nil t)))
    (format "<time datetime=\"%s\">%s</time>" datetime date)))

(org-export-define-derived-backend 'op/html 'html
  :translate-alist '((timestamp . op/html-timestamp))
  :options-alist '((:tags "TAGS" nil nil t)
                   ;; TODO: change URI to SLUG, maybe?
                   (:uri "URI" nil nil t)
                   (:draft "DRAFT" nil nil t)))

(provide 'op-html)
;;; op-html.el ends here
