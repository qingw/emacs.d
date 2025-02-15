;;; private/org/+org-reading-list.el -*- lexical-binding: t; -*-

;;; Variables

(defvar +org-reading-list-todo-state "[ ]")
(defvar +org-reading-list-file-name "reading-list.org")
(defvar +org-reading-list-file (concat org-directory "/" +org-reading-list-file-name))
(defvar +org-reading-list-headline "Reading List")
(defvar +org-watching-list-headline "Watching List")
(defvar +org-listening-list-headline "Listening List")

;;; Utils

(defun +org-reading-list/save (file headline &optional todo-state set-tags-p)
  "Refile the item under the cursor to a FILE HEADLINE with a todo-state"
  (org-mark-ring-push)
  (when todo-state (org-todo todo-state))
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile nil nil (list headline file nil pos)))
  (when set-tags-p (org-set-tags-command))
  (org-mark-ring-goto))

;;; Methods

(defun +org-reading-list/refile-to-reading-list ()
  "Refile an item to the reading list"
  (interactive)
  (+org-reading-list/save
   +org-reading-list-file
   +org-reading-list-headline
   +org-reading-list-todo-state
   t))

(defun +org-reading-list/refile-to-watching-list ()
  "Refile an item to the reading list"
  (interactive)
  (+org-reading-list/save
   +org-reading-list-file
   +org-watching-list-headline
   +org-reading-list-todo-state
   t))

(defun +org-reading-list/refile-to-listening-list ()
  "Refile an item to the reading list"
  (interactive)
  (+org-reading-list/save
   +org-reading-list-file
   +org-listening-list-headline
   +org-reading-list-todo-state
   t))

(defun +org-reading-list/org-open-reading-list-file ()
  "Open the reading list org file"
  (interactive)
  (find-file +org-reading-list-file))

(after! org-agenda
  (+org/add-to-agenda-custom-commands
   '("r" "Reading List" alltodo ""
     ((org-agenda-files (list +org-reading-list-file))
      ;; Remove the file prefix
      (org-agenda-prefix-format "  %?-12t% s")
      (org-agenda-hide-tags-regexp "TEXT\\|VIDEO\\|RESEARCH")
      (org-agenda-sorting-strategy '(todo-state-up user-defined-down timestamp-down))
      (org-super-agenda-groups '((:name "Active" :todo ("NEXT" "ACTIVE") :order 0)
                                 (:name "Research" :tag "RESEARCH" :order 3)
                                 (:name "Someday" :todo "SOMEDAY" :order 3)
                                 (:name "Articles" :tag "TEXT" :order 1)
                                 (:name "Videos" :regexp "\\(youtube\\|vimeo\\).com" :tag "VIDEO" :order 2)))))))
