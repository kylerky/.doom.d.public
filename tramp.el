;;; tramp.el -*- lexical-binding: t; -*-

(after! tramp
  (setq tramp-remote-path (append '(tramp-own-remote-path) tramp-remote-path)))
