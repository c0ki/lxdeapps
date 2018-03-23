\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slide}[2018/02/05 Slide, V1.0]
% Author: c0kinou
\RequirePackage{etoolbox}

%% Attributes
%% setter: attr{name}{value}
%% getter: ~name~
\makeatletter
\catcode`~13
\def~{\expandafter\find@attributes}
\def\attr#1#2{\@namedef{attributes.#1}{#2}}
\def\getattr#1{\ifcsname attributes.#1\endcsname\@nameuse{attributes.#1}\else\empty\fi}
\def\find@attributes#1~{\getattr{#1}}
%\def\ifattr#1#2{\if\relax\getattr{#1}\relax\else#2\fi}
\newcommand\ifattr[2]{\if\relax\getattr{#1}\relax\else#2\fi}
\makeatother

% font type options
\DeclareOption{cantarell}{\attr{fonttype}{cantarell}\attr{fonttypeoptions}{default}}
\DeclareOption{lmodern}{\attr{fonttype}{lmodern}\attr{fonttypeoptions}{}}

% document type (draft/final) options
\DeclareOption{draft}{\attr{documenttype}{draft}}
\DeclareOption{workinprogress}{\attr{documenttype}{wip}}
\DeclareOption{wip}{\attr{documenttype}{wip}}
\DeclareOption{final}{\attr{documenttype}{final}}

% Execute default options
\ExecuteOptions{cantarell,final}

% process given options
\ProcessOptions\relax

% Base class
\LoadClass[t]{beamer}

% Font type
\RequirePackage[~fonttypeoptions~]{~fonttype~}
% Filigrane
\AtEndPreamble{
    \RequirePackage[~documenttype~]{filigrane}
}

% Lang & Encoding
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{eurosym}
%%% For €
%\RequirePackage{textcomp}
\RequirePackage[shorthands=off,french]{babel}
\frenchbsetup{StandardLists=true}

% Tabular adjust
\RequirePackage{array}

\PassOptionsToPackage{hyphens}{url} % url is loaded by hyperref
\RequirePackage{fancyvrb}
\RequirePackage{hyperref}
\PassOptionsToPackage{usenames,dvipsnames}{color} % color is loaded by hyperref
\urlstyle{same}  % don't use monospace font for urls
\VerbatimFootnotes % allows verbatim text in footnotes

\AtEndPreamble{
    \pdfstringdefDisableCommands{\def\and{; }}
    \hypersetup{
        breaklinks=true,
        unicode=true,
        colorlinks=true, % Colorise les liens.
        urlcolor=blue, % Couleur des hyperliens.
        linkcolor=blue, % Couleur des liens internes.
        pdfborder={0 0 0},
    }
    \hypersetup{pdftitle={~title~}}
    \hypersetup{pdfsubject={~project~}}
    \hypersetup{pdfauthor={~author~}}
    \hypersetup{pdfcreator={~creator~}}
    \hypersetup{pdfkeywords={~keywords~}}
    \hypersetup{pdfproducer={~institute~}}
}

% Make links footnotes instead of hotlinks:
\let\oldhref\href
\renewcommand{\href}[2]{\oldhref{#1}{#2} {\tiny[\url{#1}]}}

%\IfFileExists{parskip.sty}{%
%\RequirePackage{parskip}
%}{% else
%\setlength{\parindent}{0pt}
%\setlength{\parskip}{6pt plus 2pt minus 1pt}
%}
\setlength{\emergencystretch}{3em}  % prevent overfull lines
\providecommand{\tightlist}{%
  \setlength{\itemsep}{5pt}\setlength{\parskip}{0pt}}

%\RequirePackage{listings}

\RequirePackage{longtable,booktabs}

% Graphics packages
\RequirePackage{graphicx,grffile}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight0.8\textheight\else\Gin@nat@height\fi}
\makeatother
% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
\RequirePackage[export]{adjustbox}
\RequirePackage{wrapfig}

\AtEndPreamble{
    \IfFileExists{~institute~.institute.sty}{\RequirePackage{~institute~.institute}}{}
    \RequirePackage{default.theme}
    \IfFileExists{~theme~.theme.sty}{\RequirePackage{~theme~.theme}}{}
    \IfFileExists{~institute~.theme.sty}{\RequirePackage{~institute~.theme}}{}
}

%% Counter
\setcounter{secnumdepth}{3} % On affiche une numérotation sur une profondeur de 3
\setcounter{tocdepth}{3}        % La table des matières va a une profondeur de 3
