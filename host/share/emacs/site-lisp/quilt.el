;;; quilt.el --- a minor mode for working with files in quilt

;; Copyright 2005-2007  Matt Mackall <mpm@selenic.com>
;;  Satoru Takeuchi <satoru.takeuchi@gmail.com> took over this package
;;  from Matt Mackall.

;; Author: Saotru takeuchi <satoru.takeuchi@gmail.com>
;;
;; This software may be used and distributed according to the terms
;; of the GNU General Public License, incorporated herein by reference.

;;; Commentary:
;;

;;  Add (load "~/quilt.el") to your .emacs file

;;; History:
;;

;;; Code:

(defun quilt-buffer-file-name-safe ()
  "Return buffer file name.  If buffer is not associated with any file, return nil."
  (let ((fn buffer-file-name))
    (if (and fn (file-exists-p fn))
	fn)))

(defun quilt-bottom-p ()
  "Return t if there is on the bottom of patch stack, return nil if otherwise."
  (if (> (call-process "quilt" nil nil nil "applied") 0) 1))

(defun quilt--get-config-variable (var)
  "Return the value of a configuration variable. Return nil if it is unset."
  (or (with-current-buffer (generate-new-buffer " *cmd")
        (shell-command
         (concat "if [ -f ~/.quiltrc ]; then"
                 "  . ~/.quiltrc ;"
                 "elif [ -f /etc/quilt.quiltrc ]; then"
                 "  . /etc/quilt.quiltrc ;"
                 "fi ;"
                 "echo -n $" var)
         t)
        (unwind-protect
            (let ((v (buffer-string)))
              (if (string= "" (buffer-string))
                  nil
                v))
          (kill-buffer (current-buffer))))
      (getenv var)))

(defun quilt--per-project-patches-directory ()
  (let ((qd (quilt-dir)))
    (if qd
        (let ((project-config (concat qd "/"
                                      (quilt-pc-directory) "/.quilt_patches")))
          (if (file-readable-p project-config)
              (with-temp-buffer
                (insert-file-contents-literally project-config)
                (substring (buffer-string) 0 -1)))))))

(defun quilt-patches-directory ()
  "Return the location of patch files."
  (or (quilt--per-project-patches-directory)
      (quilt--get-config-variable "QUILT_PATCHES")
      "patches"))

(defun quilt-pc-directory ()
  "Return the location of the quilt working state directory."
  (or (quilt--get-config-variable "QUILT_PC")
      ".pc"))

(defun quilt-patches-prefix ()
  "Return the value of the QUILT_PATCHES_PREFIX config variable. Return nil if it is unset."
  (quilt--get-config-variable "QUILT_PATCHES_PREFIX"))

(defun quilt-find-dir (fn &optional prefn)
  "Return the top level dir of quilt from FN."
  (if (or (not fn) (equal fn "/") (equal fn prefn))
      nil
    (let ((d (file-name-directory fn)))
      (if (file-accessible-directory-p (concat d "/" (quilt-pc-directory)))
	  d
	(quilt-find-dir (directory-file-name d) d)))))

(defun quilt-dir (&optional fn)
  "Return the top level dir of quilt from FN.  FN is just a hint and find from other way if FN is nil."
  (quilt-find-dir (if fn fn
		    (let ((fn2 (quilt-buffer-file-name-safe)))
		      (if fn2 fn2
			(if default-directory
			    (expand-file-name default-directory)))))))

(defun quilt-drop-dir (fn)
  "Return the relative path of FN based on quilt top directory."
  (let ((d (quilt-find-dir fn)))
    (substring fn (length d) (length fn))))

(defun quilt-p (&optional fn)
  "Check if FN is in a quilt tree."
  (if (quilt-dir fn) 't nil))

(defun quilt-save ()
  "Save all buffers associated with current quilt tree."
  (save-some-buffers nil 'quilt-p))

(defun quilt-owned-p (fn)
  "Check if FN is a file which quilt handles."
  (if (not fn)
      nil
    (let ((pd (file-name-nondirectory
		(directory-file-name (file-name-directory fn)))))
      (and
       (not (string-match "\\(~$\\|\\.rej$\\)" fn))
       (not (equal pd (quilt-patches-directory)))
       (not (equal pd (quilt-pc-directory)))
       (quilt-p fn)))))

(defun quilt-cmd (cmd &optional buf)
  "Execute CMD, a quilt subcommand, at the top of quilt tree associated with BUF."
  (let ((d default-directory)
	 (qd (quilt-dir)))
    (if (not qd)
	(shell-command (concat "quilt " cmd) buf)
      (cd qd)
      (unwind-protect ; make sure to cd back even if an erro occurs.
	  (shell-command (concat "quilt " cmd) buf)
	(cd d)))))

(defun quilt-cmd-to-string (cmd)
  "Execute CMD, a quilt subcommand, at the top of quilt tree associated with BUF and return its output string."
  (let ((d default-directory)
	 (qd (quilt-dir)))
    (if (not qd)
	nil
      (cd qd)
      (unwind-protect ; make sure to cd back even if an error occurs.
	  (shell-command-to-string (concat "quilt " cmd))
	(cd d)))))

(defun quilt-cmd-to-list (cmd)
  "Execute CMD, a quilt sumcommand at the top of quilt tree associated with BUF.."
  "Return the lines of the command output as elements of a list."
  (let ((s (quilt-cmd-to-string cmd)))
    (if s
        (split-string s "\n" t))))

(defun quilt-applied-list ()
  "Return the list of the applied patch names."
  (quilt-cmd-to-list "applied"))

(defun quilt-file-list ()
  "Return the list of the file names associated with current patch."
  (quilt-cmd-to-list "files"))

(defun quilt-patch-list ()
  "Return the list of the name of patches."
  (quilt-cmd-to-list "series"))

(defun quilt-files-affected (&optional first last)
  "Return the file names which modified from FIRST to LAST."
  "Omitted args are considered as current patch."
  (let ((qd (quilt-dir))
        files fp)
    (when qd
      (setq files (quilt-cmd-to-list
                   (if last
                       (if (equal first last)
                           (concat "files " first)
                         (concat "files --combine " first last))
                     (if first
                         (concat "files --combine " first)
                       "files"))))
      (setq fp files)
      (while fp
        (setcar fp (concat qd (car fp)))
        (setq fp (cdr fp)))
      files)))

(defun quilt-top-patch ()
  "Return the top patch name.  return nil if there is the bottom of patch stack."
  (if (quilt-bottom-p)
      nil
    (substring (quilt-cmd-to-string "top")  0 -1)))

(defun quilt-complete-list (p l)
  "Call 'completing-read' with prompt P and list L."
"Convert L to an alist using indices as keys.  Note that this function modifies L."
  (let ((list l)
	(n 0))
    (while list
      (setcar list (cons (car list) n))
      (setq list (cdr list))
      (setq n (1+ n))))
  (completing-read p l nil t))

(defun quilt--strip-patchname (pn)
  "Return the name of patch PN sans the path to the patches directory."
  (let ((patches-path (concat (quilt-patches-directory) "/")))
    (substring pn (length patches-path))))

(defvar quilt-edit-top-only 't)
(defun quilt-editable (f)
  "Return t if F is editable in terms of current patch.  Return nil if otherwise."
  (let ((qd (quilt-dir))
	 (fn (quilt-drop-dir f))
	 dirs result)
    (if qd
	(if (quilt-bottom-p)
	    (quilt-cmd "applied")	; to print error message
	  (setq dirs (if quilt-edit-top-only
			 (list (let ((patch (substring (quilt-cmd-to-string "top")  0 -1)))
				 (if (quilt-patches-prefix)
				     (quilt--strip-patchname patch)
				   patch)))
			 (cdr (cdr (directory-files (concat qd (quilt-pc-directory) "/"))))))
	  (while (and (not result) dirs)
	    (if (file-exists-p (concat qd (quilt-pc-directory) "/" (car dirs) "/" fn))
		(setq result t)
	      (setq dirs (cdr dirs))))
	  result))))

(defun quilt-short-patchname ()
  "Return shortened name of top patch.  Return \"none\" when on the bottom patch stack."
  (let ((p (quilt-top-patch)))
    (if (not p)
	"none"
      (let ((p2 (file-name-sans-extension (file-name-nondirectory p))))
	   (if (< (length p2) 10)
	       p2
	     (concat (substring p2 0 8) ".."))))))

(defvar quilt-mode-line nil)
(make-variable-buffer-local 'quilt-mode-line)

(defun quilt-update-modeline ()
  "Update mode line."
  (interactive)
  (setq quilt-mode-line
	(concat " Q:" (quilt-short-patchname)))
  (force-mode-line-update))

(defun quilt-revert (filelist)
  "Refresh contents, editability and modeline of FILELIST.
FILELIST won't be touched unless their file is a child of the
current quilt directory.  Each elements in FILELIST should be the absolute
file names of those files affected by the latest quilt
operation.  Associated buffers get reverted to update their
contents.  Other buffers will only get their modeline and
editability adjusted."
  (let ((qd (quilt-dir))
	fn)
    (dolist (buf (buffer-list))
      (if (not (string-match "^ " (buffer-name buf)))
	(with-current-buffer buf
	  (setq fn (quilt-buffer-file-name-safe))
	  (when (string-equal qd (quilt-dir))
	    (quilt-update-modeline)
	    (when (and (not (buffer-modified-p))
		       (quilt-owned-p fn))
	      ;; If the file doesn't exist on disk it can't be reverted, but we
	      ;; need the revert hooks to run anyway so that the buffer's
	      ;; editability will update. Files not affected by the latest change
	      ;; (as listed in filelist) don't need to get reverted either.
	      (if (and (file-exists-p buffer-file-name)
		       (member fn filelist))
		  (progn
		    (revert-buffer t t t))
		(run-hooks 'after-revert-hook)))))))))

(defun quilt-push (arg)
  "Push next patch.  It is forced if ARG is specified."
  (interactive "P")
  (quilt-save)
  (if arg
      (quilt-cmd "push -f" "*quilt*")
    (quilt-cmd "push -q"))
  (quilt-revert (quilt-files-affected)))

(defun quilt-pop (arg)
  "Pop top patch.  It is forced if ARG is specified."
  (interactive "P")
  (quilt-save)
  (if arg
      (quilt-cmd "pop -f")
    (quilt-cmd "pop -q"))
  (quilt-revert (quilt-files-affected)))

(defun quilt-push-all (arg)
  "Push all remaining patches.  It is forced if ARG is specified."
  (interactive "P")
  (quilt-save)
  (let ((next (car (quilt-cmd-to-list "next"))))
    (if arg
	(quilt-cmd "push -f" "*quilt*")
      (quilt-cmd "push -qa"))
    (quilt-revert (quilt-files-affected next))))

(defun quilt-pop-all (arg)
  "Pop all applied patches.  It is forced if ARG is specified."
  (interactive "P")
  (quilt-save)
  (let ((fa (quilt-files-affected "-")))
    (if arg
	(quilt-cmd "pop -af")
      (quilt-cmd "pop -qa"))
    (quilt-revert fa)))

(defun quilt-goto ()
  "Go to a specified patch."
  (interactive)
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (let ((arg (quilt-complete-list "Goto patch: " (quilt-patch-list))))
	(if (string-equal arg "")
	    (message "no patch name is supplied")
	  (quilt-save)
	  (let (cmd first last)
	    (if (file-exists-p (concat qd (quilt-pc-directory) "/" arg))
		(progn
		  (setq cmd "pop")
		  (setq first (car (quilt-cmd-to-list (concat "next " arg))))
		  (setq last (quilt-top-patch)))
	      (setq cmd "push")
	      (setq last arg)
	      (setq first (if (quilt-bottom-p)
			      "-"
			    (car (quilt-cmd-to-list "next")))))
	    (quilt-cmd (concat cmd " -q " arg) "*quilt*")
	  (quilt-revert (quilt-files-affected first last))))))))

(defun quilt-top ()
  "Display topmost patch."
  (interactive)
  (quilt-cmd "top"))

(defun quilt-find-file ()
  "Find a file in the topmost patch."
  (interactive)
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (if (quilt-bottom-p)
	  (quilt-cmd "applied")		; to print error message
	(let ((l (quilt-file-list)))
	  (if (not l)
	      (message "no file is existed in this patch")
	    (let ((f (quilt-complete-list "File: " l)))
	      (if (string-equal f "")
		  (message "file name is not specified")
		(find-file (concat qd f))))))))))

(defun quilt-files ()
  "Display files in topmost patch."
  (interactive)
  (quilt-cmd "files"))

(defun quilt-import (fn pn)
  "Import external patch FN as PN.patch."
  (interactive "fPatch to import: \nsPatch name: ")
  (if (not pn)
      (message "no patch name supplied")
    (quilt-cmd (concat "import -p " pn ".patch " (if fn fn pn)))))

(defun quilt-diff ()
  "Display the diff of current change."
  (interactive)
  (quilt-save)
  (quilt-cmd "diff" "*diff*"))

(defun quilt-new (f)
  "Create a new patch F.patch."
  (interactive "sPatch name: ")
  (if (string-equal f "")
      (message "no patch name is supplied")
    (quilt-save)
    (quilt-cmd (concat "new " f ".patch"))
    (quilt-revert nil)))

(defun quilt-applied ()
  "Show applied patches."
  (interactive)
  (quilt-cmd "applied" "*quilt*"))

(defun quilt-add (arg)
  "Add ARG to the current patch."
  (interactive "b")
  (with-current-buffer arg
    (let ((fn (quilt-buffer-file-name-safe)))
      (cond
       ((not fn)
	(message "buffer %s is not associated with any buffer" (buffer-name)))
       ((not (quilt-dir))
	(quilt-cmd (concat "push")))	; to print error message
       (t
	(quilt-cmd (concat "add " (quilt-drop-dir fn)))
	(quilt-revert (list fn)))))))

(defun quilt-edit-patch ()
  "Edit the topmost patch."
  (interactive)
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (let ((patch (quilt-top-patch)))
	(if (not patch)
	    (quilt-cmd "applied")	; to print error message
	  (quilt-save)
	  (let ((pf (concat qd
			    (format "/%s/" (quilt-patches-directory))
			    patch)))
	    (if (file-exists-p pf)
		(progn (find-file pf)
		       (read-only-mode 0))
	      (message (format "%s doesn't exist yet." pf)))))))))

(defun quilt-patches ()
  "Show which patches modify the current buffer."
  (interactive)
  (let ((fn (quilt-buffer-file-name-safe)))
    (cond
     ((not fn)
      (message "buffer %s is not associated with any buffer" (buffer-name)))
     ((not (quilt-dir))
      (quilt-cmd "push"))		; to print error message
     (t
      (quilt-cmd (concat "patches " (quilt-drop-dir fn)))))))

(defun quilt-unapplied ()
  "Display unapplied patch list."
  (interactive)
  (quilt-cmd "unapplied" "*quilt*"))

(defun quilt-refresh ()
  "Refresh the current patch."
  (interactive)
  (quilt-save)
  (quilt-cmd "refresh"))

(defun quilt-remove ()
  "Remove a file from the current patch and revert it."
  (interactive)
  (let ((f (quilt-buffer-file-name-safe)))
    (cond
     ((not f)
      (message "buffer %s is not associated with any patch" (buffer-name)))
     ((not (quilt-dir))
      (quilt-cmd "push")) ; to print error message
     (t
      (if (quilt-bottom-p)
	  (quilt-cmd "applied")		; to print error message
	(let ((dropped (quilt-drop-dir f)))
	  (if (y-or-n-p (format "Really drop %s? " dropped))
	      (progn
		(quilt-cmd (concat "remove " dropped))
		(quilt-revert (list f))))))))))

(defun quilt-edit-series ()
  "Edit the patch series file."
  (interactive)
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (let ((series (concat qd
			     (format "/%s/series" (quilt-patches-directory)))))
	(if (file-exists-p series)
	    (find-file series)
	  (message (quilt-top-patch)))))))

(defun quilt-header (arg)
  "Print the header of ARG."
  (interactive "P")
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (if (not arg)
	  (quilt-cmd "header")
	(let ((p (quilt-complete-list "Patch: " (quilt-patch-list))))
	  (if (string-equal p "")
	      (message "no patch name is supplied")
	    (quilt-cmd (concat "header " p))))))))

(defun quilt-delete (arg)
  "Delete ARG from the series file."
  (interactive "P")
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (let ((p (if arg
		   (quilt-complete-list "Delete patch: " (quilt-patch-list))
		 (quilt-top-patch))))
	(if (string-equal p "")
	    (message "no patch name is supplied")
	  (if (not p)
	      (quilt-cmd "applied")	; to print error message
	    (if (y-or-n-p (format "Really delete %s? " p))
		(let ((fa (quilt-files-affected p p)))
		  (quilt-save)
		  (quilt-cmd (concat "delete " p))
		  (quilt-revert fa)))))))))

(defvar quilt-header-directory nil)

(defun quilt-header-commit ()
  "Commit to change patch header."
  (interactive)
  (let ((tmp (make-temp-file "quilt-header-")))
    (set-visited-file-name tmp)
    (basic-save-buffer)
    (cd quilt-header-directory)
    (shell-command (concat "EDITOR=cat quilt -r header <" tmp))
    (kill-buffer (current-buffer))
    (delete-file tmp)))

(defvar quilt-header-mode-map (make-keymap))
(define-key quilt-header-mode-map "\C-c\C-c" 'quilt-header-commit)

(defun quilt-edit-header (arg)
  "Edit the header of ARG."
  (interactive "P")
  (let ((qd (quilt-dir)))
    (if (not qd)
	(quilt-cmd "push")		; to print error message
      (let ((p (if arg
		   (quilt-complete-list "Edit patch: " (quilt-patch-list))
		 (quilt-top-patch))))
	  (if (string-equal p "")
	      (message "no patch name is supplied")
	    (if (not p)
		(quilt-cmd "applied")	; to print error message
	      (let ((qb (get-buffer-create (format " *quilt-header(%s)*" p))))
		(switch-to-buffer-other-window qb)
		(erase-buffer)
		(kill-all-local-variables)
		(make-local-variable 'quilt-header-directory)
		(setq quilt-header-directory default-directory)
		(use-local-map quilt-header-mode-map)
		(setq major-mode 'quilt-header-mode)
		(call-process "quilt" nil qb nil "header" p)
		(goto-char 0))))))))

(defun quilt-series (arg)
  "Show patche series.  It can be verbose mode if ARG is specified."
  (interactive "P")
  (if arg
      (quilt-cmd "series -v")
    (quilt-cmd "series")))

(defvar quilt-mode-map (make-sparse-keymap))
(define-key quilt-mode-map "\C-c.t" 'quilt-top)
(define-key quilt-mode-map "\C-c.f" 'quilt-find-file)
(define-key quilt-mode-map "\C-c.F" 'quilt-files)
(define-key quilt-mode-map "\C-c.d" 'quilt-diff)
(define-key quilt-mode-map "\C-c.p" 'quilt-push)
(define-key quilt-mode-map "\C-c.o" 'quilt-pop)
(define-key quilt-mode-map "\C-c.P" 'quilt-push-all)
(define-key quilt-mode-map "\C-c.O" 'quilt-pop-all)
(define-key quilt-mode-map "\C-c.g" 'quilt-goto)
(define-key quilt-mode-map "\C-c.A" 'quilt-applied)
(define-key quilt-mode-map "\C-c.n" 'quilt-new)
(define-key quilt-mode-map "\C-c.i" 'quilt-import)
(define-key quilt-mode-map "\C-c.a" 'quilt-add)
(define-key quilt-mode-map "\C-c.e" 'quilt-edit-patch)
(define-key quilt-mode-map "\C-c.m" 'quilt-patches)
(define-key quilt-mode-map "\C-c.u" 'quilt-unapplied)
(define-key quilt-mode-map "\C-c.r" 'quilt-refresh)
(define-key quilt-mode-map "\C-c.R" 'quilt-remove)
(define-key quilt-mode-map "\C-c.s" 'quilt-series)
(define-key quilt-mode-map "\C-c.S" 'quilt-edit-series)
(define-key quilt-mode-map "\C-c.h" 'quilt-header)
(define-key quilt-mode-map "\C-c.H" 'quilt-edit-header)
(define-key quilt-mode-map "\C-c.D" 'quilt-delete)

(defvar quilt-mode nil)
(make-variable-buffer-local 'quilt-mode)

(defun quilt-mode (&optional arg)
  "Toggle 'quilt-mode'.  Enable 'quilt-mode' if ARG is positive.

\\{quilt-mode-map}"
  (interactive "P")
  (setq quilt-mode
	(if (null arg)
	    (not quilt-mode)
	  (> (prefix-numeric-value arg) 0)))
  (if quilt-mode
      (let ((f (quilt-buffer-file-name-safe)))
	(if (quilt-owned-p f)
	    (if (not (quilt-editable f))
            (read-only-mode 1)
	      (read-only-mode 0)))
	(quilt-update-modeline))))

(defun quilt-hook ()
  "Enable quilt mode for quilt-controlled files."
  (if (quilt-p) (quilt-mode 1)))

(add-hook 'find-file-hooks 'quilt-hook)
(add-hook 'after-revert-hook 'quilt-hook)

(or (assq 'quilt-mode minor-mode-alist)
    (setq minor-mode-alist
	  (cons '(quilt-mode quilt-mode-line) minor-mode-alist)))

(or (assq 'quilt-mode-map minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (cons (cons 'quilt-mode quilt-mode-map) minor-mode-map-alist)))

(provide 'quilt)

;;; quilt.el ends here
