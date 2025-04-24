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

(after! calendar
  (setq calendar-chinese-all-holidays-flag t
        calendar-date-display-form calendar-european-date-display-form
        diary-date-forms diary-european-date-forms))

(setq gnus-init-file "~/.config/doom/gnus.el")

(after! project
  (setq project-vc-extra-root-markers '(".poject.el")))

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

(after! eglot
   (setq eglot-workspace-configuration
                    (plist-put eglot-workspace-configuration
                              ':rust-analyzer
                              '(:rustc (:source "discover")
                                :check (:command "clippy")))))

(after! ispell
  (setq ispell-extra-args
        (append ispell-extra-args '("--lang=en_GB" "--camel-case"))))

(after! ob-hledger
  (add-to-list 'org-src-lang-modes '("hledger" . ledger)))

(after! browse-url
  (setq browse-url-handlers '(("." . browse-url-firefox))))

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

      (:when (modulep! :completion ivy)
        :desc "Swiper"                          "C-s"          #'swiper)

      (:when (modulep! :ui tabs)
        :desc "Tab backward"                    "C-<prior>"    #'centaur-tabs-backward
        :desc "Tab forward"                     "C-<next>"     #'centaur-tabs-forward)

      (:when (modulep! :lang racket)
        :after racket-mode
        :map racket-smart-open-bracket-mode-map
        :desc "Smart open bracket"              "C-0"            #'racket-smart-open-bracket)

      "<f5>"   #'deadgrep)

(map! :leader
      :desc "Resume the last avy action"        "C-j"        #'avy-resume
      :desc "Toggle repeat mode"                "r"          #'repeat-mode
      :desc "Aider menu"                        "'"          #'aider-transient-menu

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

(map! (:when (modulep! :emacs dired +dirvish)
        :after dirvish
        :map dirvish-mode-map
        "a"    #'dirvish-quick-access
        "f"    #'dirvish-file-info-menu
        "y"    #'dirvish-yank-menu
        "N"    #'dirvish-narrow
        "["    #'dirvish-history-last
        "h"    #'dirvish-history-jump ; remapped `describe-mode'
        "s"    #'dirvish-quicksort ; remapped `dired-sort-toggle-or-edit'
        "v"    #'dirvish-vc-menu   ; remapped `dired-view-file'
        "TAB"  #'dirvish-subtree-toggle
        "M-f"  #'dirvish-history-go-forward
        "M-b"  #'dirvish-history-go-backward
        "M-l"  #'dirvish-ls-switches-menu
        "M-m"  #'dirvish-mark-menu
        "M-t"  #'dirvish-layout-toggle
        "M-c"  #'dirvish-setup-menu
        "M-e"  #'dirvish-emerge-menu
        "M-j"  #'dirvish-fd-jump))

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
           (super-save-all-buffers t)
           (super-save-triggers
            '(ace-window
              treemacs-select-window
              persp-switch-to-buffer
              +vertico/switch-workspace-buffer
              switch-to-buffer
              consult-buffer
              other-window
              other-frame
              other-window-prefix
              other-frame-prefix
              windmove-up
              windmove-down
              windmove-left
              windmove-right
              next-buffer
              previous-buffer
              centaur-tabs-forward
              centaur-tabs-backward
              magit-status))
           (super-save-hook-triggers
            '(find-file-hook
              mouse-leave-buffer-hook
              focus-out-hook)))
  :config (super-save-mode 1))

(use-package! orderless
  :defer
  :config
  (orderless-define-completion-style +orderless-with-initialism
    (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))
  (setq completion-category-defaults nil
        completion-category-overrides '((file (styles +orderless-with-initialism partial-completion))
                                        (command (styles +orderless-with-initialism partial-completion))
                                        (variable (styles +orderless-with-initialism partial-completion))
                                        (symbol (styles +orderless-with-initialism partial-completion)))))

(use-package! rust-mode
  :defer
  :after flycheck
  :hook
  ((rust-mode . eglot-ensure))
  :custom
  ((rust-mode-treesitter-derive t)))

(use-package! rust-ts-mode
  :defer
  :after flycheck
  :hook
  ((rust-ts-mode . eglot-ensure)))

(use-package! citar
  :defer
  :custom
  ((org-cite-global-bibliography '("~/Notes/references.bib"))
   (citar-bibliography org-cite-global-bibliography)
   (org-cite-insert-processor 'citar)
   (org-cite-follow-processor 'citar)
   (org-cite-activate-processor 'citar)))

(use-package! ledger-mode
  :config (progn
            (add-to-list
             'auto-mode-alist
             '("\\.\\(h?ledger\\|journal\\|j\\)$" . ledger-mode)))
  :custom ((ledger-binary-path "hledger")
           (ledger-init-file-name nil)
           (ledger-mode-should-check-version nil)
           (ledger-post-amount-alignment-column 64)))

(use-package! aider
  :defer
  :custom
  ((aider-args '("--model" "deepseek/deepseek-reasoner"))))

(use-package! piem
  :defer
  :custom
  ((piem-inboxes '("lkml"
                   :url "https://lore.kernel.org/lkml/"
                   :address "linux-kernel@vger.kernel.org"
                   :listid "linux-kernel.vger.kernel.org"))))

(use-package! treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode 1))

(use-package! racket-mode
  :defer
  :config
  (keymap-unset racket-smart-open-bracket-mode-map "[" 'remove)
  :hook
  ((racket-mode . racket-smart-open-bracket-mode)))
