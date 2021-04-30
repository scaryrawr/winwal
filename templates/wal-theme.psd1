@{{
    Name  = 'wal'
    Types = @{{
        Directories = @{{
            symlink  = '{color14}'
            junction = '{color14}'
            WellKnown = @{{
                docs                    = '{color12}'
                documents               = '{color12}'
                desktop                 = '{color14}'
                contacts                = '{color14}'
                apps                    = '{color1}'
                applications            = '{color1}'
                shortcuts               = '{color1}'
                links                   = '{color1}'
                fonts                   = '{color1}'
                images                  = '{color2}'
                photos                  = '{color2}'
                pictures                = '{color2}'
                videos                  = '{color3}'
                movies                  = '{color3}'
                media                   = '{color14}'
                music                   = '{color9}'
                songs                   = '{color9}'
                onedrive                = '{color14}'
                downloads               = '{color14}'
                src                     = '{color10}'
                development             = '{color10}'
                projects                = '{color10}'
                bin                     = '{color14}'
                tests                   = '{color12}'
                '.config'               = '{color14}'
                '.cache'                = '{color10}'
                '.vscode'               = '{color12}'
                '.vscode-insiders'      = '{color12}'
                '.git'                  = '{color9}'
                '.github'               = '{color14}'
                'github'                = '{color14}'
                'node_modules'          = '{color2}'
                '.terraform'            = '{color12}'
                '.azure'                = '{color12}'
                '.aws'                  = '{color3}'
                '.kube'                 = '{color4}'
                '.docker'               = '{color14}'
            }}
        }}
        Files = @{{
            symlink  = '{color14}'
            junction = '{color14}'
            WellKnown = @{{
                '.gitattributes'                = '{color9}'
                '.gitconfig'                    = '{color9}'
                '.gitignore'                    = '{color9}'
                '.gitmodules'                   = '{color9}'
                '.gitkeep'                      = '{color9}'
                'git-history'                   = '{color9}'
                'LICENSE'                       = '{color5}'
                'LICENSE.md'                    = '{color5}'
                'LICENSE.txt'                   = '{color5}'
                'CHANGELOG.md'                  = '{color10}'
                'CHANGELOG.txt'                 = '{color10}'
                'CHANGELOG'                     = '{color10}'
                'README.md'                     = '{color14}'
                'README.txt'                    = '{color14}'
                'README'                        = '{color14}'
                '.DS_Store'                     = '{color8}'
                '.tsbuildinfo'                  = '{color11}'
                '.jscsrc'                       = '{color11}'
                '.jshintrc'                     = '{color11}'
                'tsconfig.json'                 = '{color11}'
                'tslint.json'                   = '{color11}'
                'composer.lock'                 = '{color11}'
                '.jsbeautifyrc'                 = '{color11}'
                '.esformatter'                  = '{color11}'
                'cdp.pid'                       = '{color11}'
                '.htaccess'                     = '{color2}'
                '.jshintignore'                 = '{color12}'
                '.buildignore'                  = '{color12}'
                '.mrconfig'                     = '{color12}'
                '.yardopts'                     = '{color12}'
                'manifest.mf'                   = '{color12}'
                '.clang-format'                 = '{color12}'
                '.clang-tidy'                   = '{color12}'
                'favicon.ico'                   = '{color11}'
                '.travis.yml'                   = 'FFE4B5'
                '.gitlab-ci.yml'                = '{color9}'
                '.jenkinsfile'                  = '{color12}'
                'bitbucket-pipelines.yml'       = '{color12}'
                'bitbucket-pipelines.yaml'      = '{color12}'
                '.azure-pipelines.yml'          = '{color12}'

                # Firebase
                'firebase.json'                 = '{color3}'
                '.firebaserc'                   = '{color3}'

                # Bower
                '.bowerrc'                      = '{color5}'
                'bower.json'                    = '{color5}'

                # Conduct
                'code_of_conduct.md'            = '{color15}'
                'code_of_conduct.txt'           = '{color15}'

                # Docker
                'Dockerfile'                    = '{color12}'
                'docker-compose.yml'            = '{color12}'
                'docker-compose.yaml'           = '{color12}'
                'docker-compose.dev.yml'        = '{color12}'
                'docker-compose.local.yml'      = '{color12}'
                'docker-compose.ci.yml'         = '{color12}'
                'docker-compose.override.yml'   = '{color12}'
                'docker-compose.staging.yml'    = '{color12}'
                'docker-compose.prod.yml'       = '{color12}'
                'docker-compose.production.yml' = '{color12}'
                'docker-compose.test.yml'       = '{color12}'

                # Vue
                'vue.config.js'                 = '{color8}'
                'vue.config.ts'                 = '{color8}'

                # Gulp
                'gulpfile.js'                   = '{color5}'
                'gulpfile.ts'                   = '{color5}'
                'gulpfile.babel.js'             = '{color5}'

                # NodeJS
                'package.json'                  = '{color2}'
                'package-lock.json'             = '{color2}'
                '.nvmrc'                        = '{color2}'
                '.esmrc'                        = '{color2}'

                # NPM
                '.nmpignore'                    = '{color12}'
                '.npmrc'                        = '{color12}'

                # Authors
                'authors'                       = '{color3}'
                'authors.md'                    = '{color3}'
                'authors.txt'                   = '{color3}'

                # Terraform
                '.terraform.lock.hcl'           = '{color12}'
            }}
            # Archive files
            '.7z'                   = '{color10}'
            '.bz'                   = '{color10}'
            '.tar'                  = '{color10}'
            '.zip'                  = '{color10}'
            '.gz'                   = '{color10}'
            '.xz'                   = '{color10}'
            '.br'                   = '{color10}'
            '.bzip2'                = '{color10}'
            '.gzip'                 = '{color10}'
            '.brotli'               = '{color10}'
            '.rar'                  = '{color10}'
            '.tgz'                  = '{color10}'

            # Executable things
            '.bat'                  = '{color2}'
            '.cmd'                  = '{color2}'
            '.exe'                  = '{color14}'
            '.pl'                   = '{color5}'

            '.sh'                   = '{color9}'

            # PowerShell
            '.ps1'                  = '{color12}'
            '.psm1'                 = '{color12}'
            '.psd1'                 = '{color12}'
            '.ps1xml'               = '{color12}'
            '.psc1'                 = '{color12}'
            'pssc'                  = '{color12}'

            # Javascript
            '.js'                   = '{color10}'
            '.esx'                  = '{color10}'
            '.mjs'                  = '{color10}'

            # Java
            '.java'                 = '{color3}'

            # Python
            '.py'                   = '{color12}'

            # React
            '.jsx'                  = '{color14}'
            '.tsx'                  = '{color14}'

            # Typescript
            '.ts'                   = '{color10}'

            # Not-executable code files
            '.dll'                  = '{color12}'

            # Importable Data files
            '.clixml'               = '{color12}'
            '.csv'                  = '{color2}'
            '.tsv'                  = '{color2}'

            # Settings
            '.ini'                  = '{color12}'
            '.dlc'                  = '{color12}'
            '.config'               = '{color12}'
            '.conf'                 = '{color12}'
            '.properties'           = '{color12}'
            '.prop'                 = '{color12}'
            '.settings'             = '{color12}'
            '.option'               = '{color12}'
            '.reg'                  = '{color12}'
            '.props'                = '{color12}'
            '.toml'                 = '{color12}'
            '.prefs'                = '{color12}'
            '.sln.dotsettings'      = '{color12}'
            '.sln.dotsettings.user' = '{color12}'
            '.cfg'                  = '{color12}'

            # Source Files
            '.c'                    = '{color14}'
            '.cpp'                  = '{color14}'
            '.go'                   = '{color14}'
            '.php'                  = '{color6}'

            # Visual Studio
            '.csproj'               = '{color13}'
            '.ruleset'              = '{color13}'
            '.sln'                  = '{color13}'
            '.suo'                  = '{color13}'
            '.vb'                   = '{color13}'
            '.vbs'                  = '{color13}'
            '.vcxitems'             = '{color13}'
            '.vcxitems.filters'     = '{color13}'
            '.vcxproj'              = '{color13}'
            '.vsxproj.filters'      = '{color13}'

            # CSharp
            '.cs'                   = '{color5}'
            '.csx'                  = '{color5}'

            # Haskell
            '.hs'                   = '{color5}'

            # XAML
            '.xaml'                 = '{color12}'

            # Rust
            '.rs'                   = '{color9}'

            # Database
            '.pdb'                  = '{color11}'
            '.sql'                  = '{color11}'
            '.pks'                  = '{color11}'
            '.pkb'                  = '{color11}'
            '.accdb'                = '{color11}'
            '.mdb'                  = '{color11}'
            '.sqlite'               = '{color11}'
            '.pgsql'                = '{color11}'
            '.postgres'             = '{color11}'
            '.psql'                 = '{color11}'

            # Source Control
            '.patch'                = '{color9}'

            # Project files
            '.user'                 = '{color12}'
            '.code-workspace'       = '{color12}'

            # Text data files
            '.log'                  = '{color10}'
            '.txt'                  = '{color2}'

            # HTML/css
            '.html'                 = '{color5}'
            '.htm'                  = '{color5}'
            '.xhtml'                = '{color5}'
            '.html_vm'              = '{color5}'
            '.asp'                  = '{color5}'
            '.css'                  = '{color12}'
            '.sass'                 = '{color5}'
            '.less'                 = '{color2}'

            # Markdown
            '.md'                   = '{color12}'
            '.markdown'             = '{color12}'
            '.rst'                  = '{color12}'

            # JSON
            '.json'                 = '{color11}'
            '.tsbuildinfo'          = '{color11}'

            # YAML
            '.yml'                  = '{color3}'
            '.yaml'                 = '{color3}'

            # LUA
            '.lua'                  = '{color12}'

            # Clojure
            '.clj'                  = '{color10}'
            '.cljs'                 = '{color10}'
            '.cljc'                 = '{color10}'

            # Groovy
            '.groovy'               = '{color12}'

            # Vue
            '.vue'                  = '{color14}'

            # Dart
            '.dart'                 = '{color12}'

            # Elixir
            '.ex'                   = '{color8}'
            '.exs'                  = '{color8}'
            '.eex'                  = '{color8}'
            '.leex'                 = '{color8}'

            # Erlang
            '.erl'                  = '{color3}'

            # Elm
            '.elm'                  = '{color5}'

            # Applescript
            '.applescript'          = '{color12}'

            # XML
            '.xml'                  = '{color10}'
            '.plist'                = '{color10}'
            '.xsd'                  = '{color10}'
            '.dtd'                  = '{color10}'
            '.xsl'                  = '{color10}'
            '.xslt'                 = '{color10}'
            '.resx'                 = '{color10}'
            '.iml'                  = '{color10}'
            '.xquery'               = '{color10}'
            '.tmLanguage'           = '{color10}'
            '.manifest'             = '{color10}'
            '.project'              = '{color10}'

            # Documents
            '.chm'                  = '{color12}'
            '.pdf'                  = '{color5}'

            # Excel
            '.xls'                  = '{color2}'
            '.xlsx'                 = '{color2}'

            # PowerPoint
            '.pptx'                 = '{color1}'
            '.ppt'                  = '{color1}'
            '.pptm'                 = '{color1}'
            '.potx'                 = '{color1}'
            '.potm'                 = '{color1}'
            '.ppsx'                 = '{color1}'
            '.ppsm'                 = '{color1}'
            '.pps'                  = '{color1}'
            '.ppam'                 = '{color1}'
            '.ppa'                  = '{color1}'

            # Word
            '.doc'                  = '{color12}'
            '.docx'                 = '{color12}'
            '.rtf'                  = '{color12}'

            # Audio
            '.mp3'                  = '{color9}'
            '.flac'                 = '{color9}'
            '.m4a'                  = '{color9}'
            '.wma'                  = '{color9}'
            '.aiff'                 = '{color9}'

            # Images
            '.png'                  = '{color14}'
            '.jpeg'                 = '{color14}'
            '.jpg'                  = '{color14}'
            '.gif'                  = '{color14}'
            '.ico'                  = '{color14}'
            '.tif'                  = '{color14}'
            '.tiff'                 = '{color14}'
            '.psd'                  = '{color14}'
            '.psb'                  = '{color14}'
            '.ami'                  = '{color14}'
            '.apx'                  = '{color14}'
            '.bmp'                  = '{color14}'
            '.bpg'                  = '{color14}'
            '.brk'                  = '{color14}'
            '.cur'                  = '{color14}'
            '.dds'                  = '{color14}'
            '.dng'                  = '{color14}'
            '.eps'                  = '{color14}'
            '.exr'                  = '{color14}'
            '.fpx'                  = '{color14}'
            '.gbr'                  = '{color14}'
            '.img'                  = '{color14}'
            '.jbig2'                = '{color14}'
            '.jb2'                  = '{color14}'
            '.jng'                  = '{color14}'
            '.jxr'                  = '{color14}'
            '.pbm'                  = '{color14}'
            '.pgf'                  = '{color14}'
            '.pic'                  = '{color14}'
            '.raw'                  = '{color14}'
            '.webp'                 = '{color14}'
            '.svg'                  = '{color11}'

            # Video
            '.webm'                 = '{color3}'
            '.mkv'                  = '{color3}'
            '.flv'                  = '{color3}'
            '.vob'                  = '{color3}'
            '.ogv'                  = '{color3}'
            '.ogg'                  = '{color3}'
            '.gifv'                 = '{color3}'
            '.avi'                  = '{color3}'
            '.mov'                  = '{color3}'
            '.qt'                   = '{color3}'
            '.wmv'                  = '{color3}'
            '.yuv'                  = '{color3}'
            '.rm'                   = '{color3}'
            '.rmvb'                 = '{color3}'
            '.mp4'                  = '{color3}'
            '.mpg'                  = '{color3}'
            '.mp2'                  = '{color3}'
            '.mpeg'                 = '{color3}'
            '.mpe'                  = '{color3}'
            '.mpv'                  = '{color3}'
            '.m2v'                  = '{color3}'

            # Email
            '.ics'                  = '{color2}'

            # Certifactes
            '.cer'                  = '{color3}'
            '.cert'                 = '{color3}'
            '.crt'                  = '{color3}'
            '.pfx'                  = '{color3}'

            # Keys
            '.pem'                  = '{color10}'
            '.pub'                  = '{color10}'
            '.key'                  = '{color10}'
            '.asc'                  = '{color10}'
            '.gpg'                  = '{color10}'

            # Fonts
            '.woff'                 = '{color1}'
            '.woff2'                = '{color1}'
            '.ttf'                  = '{color1}'
            '.eot'                  = '{color1}'
            '.suit'                 = '{color1}'
            '.otf'                  = '{color1}'
            '.bmap'                 = '{color1}'
            '.fnt'                  = '{color1}'
            '.odttf'                = '{color1}'
            '.ttc'                  = '{color1}'
            '.font'                 = '{color1}'
            '.fonts'                = '{color1}'
            '.sui'                  = '{color1}'
            '.ntf'                  = '{color1}'
            '.mrg'                  = '{color1}'

            # Ruby
            '.rb'                   = '{color1}'
            '.erb'                  = '{color1}'
            '.gemfile'              = '{color1}'

            # FSharp
            '.fs'                   = '{color12}'
            '.fsx'                  = '{color12}'
            '.fsi'                  = '{color12}'
            '.fsproj'               = '{color12}'

            # Docker
            '.dockerignore'         = '{color12}'
            '.dockerfile'           = '{color12}'


            # VSCode
            '.vscodeignore'         = '{color12}'
            '.vsixmanifest'         = '{color12}'
            '.vsix'                 = '{color12}'
            '.code-workplace'       = '{color12}'

            # Sublime
            '.sublime-project'      = '{color11}'
            '.sublime-workspace'    = '{color11}'

            '.lock'                 = '{color10}'

            # Terraform
            '.tf'                   = '{color12}'
            '.tfvars'               = '{color12}'
            '.auto.tfvars'          = '{color12}'
        }}
    }}
}}