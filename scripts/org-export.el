(require 'cl-lib)
(require 'org)
(require 'ox-html)

(setq org-html-htmlize-output-type nil)
(setq org-export-time-stamp-file nil)
(setq org-html-postamble nil)
(setq org-use-sub-superscripts '{})
(setq org-export-with-sub-superscripts '{})

(defun content-stager--deterministic-org-export-new-reference (references counter)
  (let ((new counter))
    (while (rassq new references) (setq new (1+ new)))
    new))

(defun content-stager/export-org-to-html (input output)
  (let ((coding-system-for-write 'utf-8-unix))
    (with-current-buffer (find-file-noselect input)
      (unwind-protect
          (let ((counter 0))
            (cl-letf (((symbol-function 'org-export-new-reference)
                       (lambda (references)
                         (prog1
                             (content-stager--deterministic-org-export-new-reference references counter)
                           (setq counter (1+ counter))))))
              (org-export-to-file 'html output)))
        (kill-buffer (current-buffer))))))
