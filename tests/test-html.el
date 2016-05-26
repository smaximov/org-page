;;; test-html.el --- Tests for op-html.el -*- lexical-binding: t -*-

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

;;; Code:

(require 'buttercup)
(require 'op-html)

(describe "Custom HTML export backend"
  (describe "Timestamp transcoder"

    (before-all
      ;; Set UTC as the local time zone
      (set-time-zone-rule t))

    (after-all
      ;; Restore the default time zone
      (set-time-zone-rule nil))

    (it "Should transcode timestamps as `<time>` elements"
      (expect (org-export-string-as "<2016-05-26>" 'op/html t nil)
              :to-equal "<p>\n<time datetime=\"2016-05-26T00:00:00.000Z\">2016-05-26</time></p>\n"))

    (it "Should respect locale-specific date format strings"
      (expect (org-export-string-as "<2016-05-26>" 'op/html t
                                    '(:locale (:date-format "%d.%m.%Y")))
              :to-equal "<p>\n<time datetime=\"2016-05-26T00:00:00.000Z\">26.05.2016</time></p>\n")))

  ;; TODO: move to a more appropriate location
  (describe "Metadata"
    (it "Should provide extra Org options"
      (with-temp-buffer
        (insert "
#+TITLE:       Some title
#+AUTHOR:      Some author
#+EMAIL:       user@example.com
#+DATE:        2016-05-20 Fri
#+URI:         /category/%y/%m/%d/name
#+KEYWORDS:    keyword1, keyword2
#+TAGS:        tag1, tag2
#+LANGUAGE:    en
#+DRAFT:       yes
#+OPTIONS:     H:3 num:nil toc:t \n:nil ::t |:t ^:nil -:nil f:t *:t <:t
#+DESCRIPTION: Some description

Some text
")
        (let ((meta (op/read-org-metadata)))
          (expect (op/get-tags meta)
                  :to-equal '("tag1" "tag2"))
          (expect (op/get-uri meta)
                  :to-equal "/category/%y/%m/%d/name")
          (expect (op/draft? meta)
                  :to-be-truthy)
          (expect (op/get-keywords meta)
                  :to-equal '("keyword1" "keyword2")))))))

(provide 'test-html)
;;; test-html.el ends here
