;;; publish.el --- publish org-mode site
;; author: alexforsale <alexforsale@yahoo.com>

;;; Commentary:
;; This script converts org-mode files into html.
;; heavily based on psachin.gitlab.io
;; gitlab.com:psachin/psachin.gitlab.io.git

;;; Code:

(require 'package)
(package-initialize)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(unless package-archive-contents
  (package-refresh-contents))
(package-install 'htmlize)
(package-install 'org-contrib)
(package-install 'ox-reveal)

(require 'org)
(require 'ox-publish)
(require 'htmlize) ;; required for ox-reveal to load Emacs theme
;; (require 'ox-html)
;; (require 'ox-rss)
(require 'ox-reveal)

(setq org-export-with-section-numbers nil
      org-export-with-smart-quotes t
      org-export-with-toc nil
      user-full-name "Kristian Alexander P"
      user-mail-address "alexforsale@yahoo.com")

(defvar this-date-format "%b %d, %Y")

(setq org-html-divs '((preamble "header" "top")
                      (content "main" "content")
                      (postamble "footer" "postamble"))
      org-html-container-element "section"
      org-html-metadata-timestamp-format this-date-format
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link t
      org-html-doctype "html5"
      org-html-htmlize-output-type 'css
      org-src-fontify-natively t)

(setq +publish-root "/blog")

(defvar me/website-html-head
  (concat
   "<link rel='icon' type='image/x-icon' href='" +publish-root "/images/favicon.jpg'/>"
   "<meta name='viewport' content='width=device-width, initial-scale=1'>"
   "<link rel='stylesheet' href='https://code.cdn.mozilla.net/fonts/fira.css'>"
   "<link rel='stylesheet' href='" +publish-root "/css/site.css' type='text/css'/>"
   "<link rel='stylesheet' href='" +publish-root "/css/custom.css' type='text/css'/>"
   "<link rel='stylesheet' href='" +publish-root "/css/syntax-coloring.css' type='text/css'/>"))

(defun onelevel/website-html-preamble (plist)
  "PLIST: An entry."
  (if (org-export-get-date plist this-date-format)
        (plist-put plist
             :subtitle (format "Published on %s by %s."
                               (org-export-get-date plist this-date-format)
                               (car (plist-get plist :author)))))
  ;; Preamble
  (with-temp-buffer
    (insert-file-contents "../html-templates/preamble.html") (buffer-string)))

(defun onelevel/website-html-postamble (plist)
  "PLIST."
  (concat (format
           (with-temp-buffer
             (insert-file-contents "../html-templates/postamble.html") (buffer-string))
           (format-time-string this-date-format (plist-get plist :time)) (plist-get plist :creator))))

(defun root/website-html-preamble (plist)
  "PLIST: An entry."
  (if (org-export-get-date plist this-date-format)
        (plist-put plist
             :subtitle (format "Published on %s by %s."
                               (org-export-get-date plist this-date-format)
                               (car (plist-get plist :author)))))
  ;; Preamble
  (with-temp-buffer
    (insert-file-contents "html-templates/preamble.html") (buffer-string)))

(defun root/website-html-postamble (plist)
  "PLIST."
  (concat (format
           (with-temp-buffer
             (insert-file-contents "html-templates/postamble.html") (buffer-string))
           (format-time-string this-date-format (plist-get plist :time)) (plist-get plist :creator))))

(defvar site-attachments
  (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                "ico" "cur" "css" "js" "woff" "html" "pdf" "txt"))
  "File types that are published as static files.")


(defun me/org-sitemap-format-entry (entry style project)
  "Format posts with author and published data in the index page.

ENTRY: file-name
STYLE:
PROJECT: `posts in this case."
  (cond ((not (directory-name-p entry))
         (format "*[[file:%s][%s]]*
                 #+HTML: <p class='pubdate'>by %s on %s.</p>"
                 entry
                 (org-publish-find-title entry project)
                 (car (org-publish-find-property entry :author project))
                 (format-time-string this-date-format
                                     (org-publish-find-date entry project))))
        ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
        (t entry)))


(setq org-publish-project-alist
      `(("posts"
         :base-directory "posts/"
         :base-extension "org"
         :recursive t
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public/posts/"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org"))
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Blog Index"
         :sitemap-format-entry me/org-sitemap-format-entry
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         :html-link-home ,+publish-root
         :html-link-up ,+publish-root
         :html-head-include-scripts t
         :html-head-include-default-style nil
         :html-head ,me/website-html-head
         :html-preamble onelevel/website-html-preamble
         :html-postamble onelevel/website-html-postamble
         :with-drawers t
         :with-priority t
         :with-properties t)
        ("onehouraday"
         :base-directory "onehouraday/"
         :base-extension "org"
         :recursive t
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public/onehouraday/"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org"))
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "What I've learned so far..."
         :sitemap-format-entry me/org-sitemap-format-entry
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         :html-link-home ,+publish-root
         :html-link-up ,+publish-root
         :html-head-include-scripts t
         :html-head-include-default-style nil
         :html-head ,me/website-html-head
         :html-preamble onelevel/website-html-preamble
         :html-postamble onelevel/website-html-postamble
         :with-drawers t
         :with-priority t
         :with-properties t)
        ("pages"
         :base-directory ,(expand-file-name (getenv "PWD"))
         :base-extension "org"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org" "template.org"))
         :recursive nil
         :publishing-function org-html-publish-to-html
         :publishing-directory "public/"
         :html-link-home ,+publish-root
         :html-link-up ,+publish-root
         :auto-sitemap nil
         :html-head-include-scripts t
         :html-head-include-default-style nil
         :html-head ,me/website-html-head
         :html-preamble root/website-html-preamble
         :html-postamble root/website-html-postamble
         :with-drawers t
         :with-priority t
         :with-properties t)
        ("css"
         :base-directory "./css"
         :base-extension "css"
         :publishing-directory "./public/css"
         :publishing-function org-publish-attachment
         :recursive t)
        ("images"
         :base-directory "./images"
         :base-extension ,site-attachments
         :publishing-directory "./public/images"
         :publishing-function org-publish-attachment
         :recursive t)
        ("assets"
         :base-directory "./assets"
         :base-extension ,site-attachments
         :publishing-directory "./public/assets"
         :publishing-function org-publish-attachment
         :recursive t)
        ;; ("rss"
        ;;  :base-directory "posts"
        ;;  :base-extension "org"
        ;;  :html-link-home ,(if (getenv "ROOT_URL")
        ;;                      (concat (getenv "ROOT_URL")
        ;;                              +publish-root)
        ;;                    (concat "https://java281.dynv6.net" +publish-root))
        ;;  :rss-link-home ,(if (getenv "ROOT_URL")
        ;;                      (concat (getenv "ROOT_URL")
        ;;                              +publish-root)
        ;;                    (concat "https://java281.dynv6.net" +publish-root))
        ;;  :html-link-use-abs-url t
        ;;  :rss-extension "xml"
        ;;  :publishing-directory "./public"
        ;;  :publishing-function (org-rss-publish-to-rss)
        ;;  :section-number nil
        ;;  :exclude ".*"
        ;;  :include ("index.org")
        ;;  :table-of-contents nil)
        ("all" :components ("posts" "pages" "onehouraday" "css" "images" "assets"))))

(provide ':publish)
;;; publish.el ends here
