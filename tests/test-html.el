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

    ;; Set UTC as the local time zone
    (set-time-zone-rule t)

    (it "Should transcode timestamps as `<time>` elements"
      (expect (org-export-string-as "<2016-05-26>" 'op/html t nil)
              :to-equal "<p>\n<time datetime=\"2016-05-26T00:00:00.000Z\">26.05.2016</time></p>\n"))))

(provide 'test-html)
;;; test-html.el ends here
