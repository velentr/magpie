;;; SPDX-FileCopyrightText: 2023 Brian Kubisiak <brian@kubisiak.com>
;;;
;;; SPDX-License-Identifier: GPL-3.0-only

(use-modules (gnu packages python)
             (gnu packages version-control)
             (guix build utils)
             (guix build-system copy)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages))

(package
 (name "magpie")
 (version "0.0.0")
 (source (local-file "." "magpie" #:recursive? #t))
 (build-system copy-build-system)
 (arguments
  '(#:phases
    (modify-phases %standard-phases
      (add-before 'install 'patch-input-paths
        (lambda* (#:key inputs #:allow-other-keys)
          (let ((git (assoc-ref inputs "git")))
            (substitute* '("magpie-git-init" "magpie-git-sync")
              (("git") (string-append git "/bin/git")))))))
    #:install-plan '(("magpie" "bin/magpie")
                      ("magpie-git-init" "bin/magpie-git-init")
                      ("magpie-git-sync" "bin/magpie-git-sync"))))
 (inputs
  (list git python))
 (synopsis "Simple scriptable backup script")
 (description "Magpie is a simple backup script that treats data as a set of
channels. Each channel is synchronized with a remote using an engine. Magpie is
designed to be easily extensible to add new engines with different
capabilities.")
 (home-page "https://github.com/velentr/magpie")
 (license license:gpl3))
