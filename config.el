;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 30 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 32))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (expand-file-name "~/Notes"))
(setq org-agenda-files (expand-file-name "agenda_files" org-directory))

(setq holiday-hebrew-holidays nil)
(setq holiday-bahai-holidays nil)
(setq holiday-islamic-holidays nil)
(setq holiday-christian-holidays nil)

(setq org-modules '(ol-bbdb
                    ol-bibtex
                    org-crypt
                    ol-docview
                    ol-doi
                    ol-eww
                    ol-gnus
                    org-habit
                    org-id
                    ol-info
                    org-inlinetask
                    ol-irc
                    ol-mhe
                    org-protocol
                    ol-rmail
                    org-tempo
                    ol-w3m))
(setq org-export-backends '(md
                            ascii
                            html
                            icalendar
                            latex
                            odt
                            org))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(map! (:when (modulep! :config default)
        :desc "Jump to a character"               "C-:"        #'avy-goto-char-2
        :desc "Go to a line by avy"               "M-g g"      #'avy-goto-line)

      (:when (modulep! :checkers syntax)
        :desc "Go to the previous error"        "M-p"          #'flycheck-previous-error
        :desc "Go to the next error"            "M-n"          #'flycheck-next-error)

      "<f5>"   #'deadgrep)

(map! :leader
      :desc "Resume the last avy action"        "C-j"        #'avy-resume
      :desc "Toggle repeat mode"                "r"          #'repeat-mode

      (:after consult
       :prefix "s"
       :desc "Consult flycheck errors"          "!"        #'consult-flycheck
       :desc "Consult the outline"              "g"        #'consult-outline)

      (:prefix ("l" . "<localleader>")
               (:after org-transclusion
                :map org-mode-map
                :desc "Remove a transclusion"           "L r"  #'org-transclusion-remove
                :desc "Add a transclusion"              "L a"  #'org-transclusion-add
                :desc "Source file of a transclusion"   "L s"  #'org-transclusion-open-source
                :desc "Transclusion from a link"        "L l"  #'org-transclusion-make-from-link
                :desc "Org Transclusion mode"           "L t"  #'org-transclusion-mode)))

(use-package! org-noter
  :defer
  :custom
  ((org-noter-notes-search-path '("~/Sync/notes"))))

(use-package! citar-embark
  :after (citar embark)
  :config (citar-embark-mode))

(use-package! citar-org-roam
  :after (citar org-roam)
  :config (citar-org-roam-mode))

(use-package! org-roam
  :defer
  :custom
  ((org-roam-directory (expand-file-name "roam" org-directory))
   (org-roam-capture-templates
    '(("m" "main" plain "%?"
       :if-new
       (file+head
        "main/${slug}.org" "#+title: ${title}\n")
       :immediate-finish t
       :unnarrowed t)
      ("r" "reference" plain "%?"
       :if-new
       (file+head
        "reference/${slug}.org" "#+title: ${title}\n#+filetags: :reference:\n")
       :immediate-finish t
       :unnarrowed t)
      ("p" "project" plain "%?"
       :if-new
       (file+head
        "project/${slug}.org" "#+title: ${title}\n#+filetags: :project:\n")
       :immediate-finish t
       :unnarrowed t))))
  :config
  (progn (require 'org-roam-protocol)
         (require 'org-roam-export)
         (org-roam-db-autosync-mode)))

(use-package! org-transclusion
  :after org
  :custom
  ((org-transclusion-extensions '(org-transclusion-src-lines
                                  org-transclusion-font-lock
                                  org-transclusion-indent-mode)))
  :config
  (progn (set-face-attribute 'org-transclusion-fringe
                             nil
                             :foreground (doom-color 'orange)
                             :background (doom-color 'orange))
         (set-face-attribute 'org-transclusion-source-fringe
                             nil
                             :foreground (doom-color 'green)
                             :background (doom-color 'green))))

(use-package! deadgrep
  :defer)

(use-package! vlf
  :init (require 'vlf-setup))

(use-package! super-save
  :custom ((auto-save-default nil)
           (super-save-auto-save-when-idle t)
           (super-save-triggers
              '(ace-window
                  treemacs-select-window
                        persp-switch-to-buffer*
                        persp-switch-to-buffer
                  other-window
                  windmove-up
                  windmove-down
                  windmove-left
                  windmove-right
                  next-buffer
                  previous-buffer
                        find-file))
           (super-save-hook-triggers
              '(find-file-hook
                  mouse-leave-buffer-hook
                  focus-out-hook)))
  :config (super-save-mode 1))
