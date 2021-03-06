\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{document}[2016/11/30 Document, V1.0]
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
\newcommand\ifnoattr[2]{\if\relax\getattr{#1}\relax#2\fi}
\makeatother

% font size options
\DeclareOption{10pt}{\attr{documentsize}{10pt}}
\DeclareOption{11pt}{\attr{documentsize}{11pt}}
\DeclareOption{12pt}{\attr{documentsize}{12pt}}

% font type options
\DeclareOption{sans}{\renewcommand{\familydefault}{\sfdefault}}
\DeclareOption{roman}{\renewcommand{\familydefault}{\rmdefault}}

% font type options
\DeclareOption{cantarell}{\attr{fonttype}{cantarell}\attr{fonttypeoptions}{default}}
\DeclareOption{lmodern}{\attr{fonttype}{lmodern}\attr{fonttypeoptions}{}}

% document type (draft/final) options
\DeclareOption{draft}{\attr{documenttype}{draft}}
\DeclareOption{workinprogress}{\attr{documenttype}{wip}}
\DeclareOption{wip}{\attr{documenttype}{wip}}
\DeclareOption{validation}{\attr{documenttype}{validation}}
\DeclareOption{final}{\attr{documenttype}{final}}
\DeclareOption{internal}{\attr{documenttype}{internal}}

% Execute default options
\ExecuteOptions{11pt,sans,cantarell,final}

% process given options
\ProcessOptions\relax

% Base class
\LoadClass[a4paper,~documentsize~,~documenttype~,]{article}

% Font type
\RequirePackage[~fonttypeoptions~]{~fonttype~}
% Filigrane
\AtEndPreamble{
    \RequirePackage[~documenttype~]{filigrane}
}
% Code
\AtEndPreamble{
    \RequirePackage{code}
}
% Custom color
\RequirePackage{customcolor}

% Multicolumns
\RequirePackage{multicol}

% Lang & Encoding
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{soulutf8}
\RequirePackage{eurosym}
%%% For €
%\RequirePackage{textcomp}
\RequirePackage[shorthands=off,french]{babel}
\frenchbsetup{StandardLists=true}

% Margin
\RequirePackage[left=2cm,right=2cm,top=2.5cm,bottom=2.5cm]{geometry}

% Tabular adjust
\RequirePackage{array}

%\RequirePackage{amssymb,amsmath}
%\RequirePackage{ifxetex,ifluatex}
%\RequirePackage{fixltx2e} % provides \textsubscript

% use upquote if available, for straight quotes in verbatim environments
%\IfFileExists{upquote.sty}{\RequirePackage{upquote}}{}

\PassOptionsToPackage{hyphens}{url} % url is loaded by hyperref
\RequirePackage{fancyvrb}
\RequirePackage[unicode=true]{hyperref}
\PassOptionsToPackage{usenames,dvipsnames}{color} % color is loaded by hyperref
\urlstyle{same}  % don't use monospace font for urls
\VerbatimFootnotes % allows verbatim text in footnotes
\RequirePackage{soul} % for highlight (\hl)

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
    \hypersetup{pdftitle=\getattr{title}\ifattr{subtitle}{: \getattr{subtitle}}}
    \hypersetup{pdfsubject=\getattr{project}}
    \hypersetup{pdfauthor=\getattr{author}}
    \hypersetup{pdfcreator=\getattr{creator}}
    \hypersetup{pdfkeywords=\getattr{keywords}}
    \hypersetup{pdfproducer=\getattr{institute}}
}

% Make links footnotes instead of hotlinks:
\let\oldhref\href
\renewcommand{\href}[2]{\oldhref{#1}{#2}\footnote{#2: \url{#1}}}

\IfFileExists{parskip.sty}{%
\RequirePackage{parskip}
}{% else
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
}
\setlength{\emergencystretch}{3em}  % prevent overfull lines
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}

\RequirePackage{listings}

% List
\RequirePackage{enumitem}
\setlist[description]{style=nextline, itemsep=1em}
\let\origdescription\description
\renewenvironment{description}{
\def\tightlist{%
  \setlength{\itemsep}{\the\parskip}}
  \let\origitemize\itemize
  \renewenvironment{itemize}{
    \def\tightlist{%
      \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
    \origitemize[leftmargin=3em,topsep=-\the\parskip]}

  \origdescription
}
{\endlist}

\RequirePackage{longtable,booktabs}
% Fix footnotes in tables (requires footnote package)
\IfFileExists{footnote.sty}{\RequirePackage{footnote}\makesavenoteenv{long table}}{}

% Graphics packages
\RequirePackage{graphicx,grffile}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\makeatother
% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
\RequirePackage[export]{adjustbox}
\RequirePackage{wrapfig}

% Overwrite \begin{figure}[htbp] with \begin{figure}[H]
\RequirePackage{float}
\let\origfigure=\figure
\let\endorigfigure=\endfigure
\renewenvironment{figure}[1][]{%
  \origfigure[H]
}{%
  \endorigfigure
}

\RequirePackage{default.theme}
\AtEndPreamble{
    \IfFileExists{~institute~.institute.sty}{\RequirePackage{~institute~.institute}}{}
    \IfFileExists{~theme~.theme.sty}{\RequirePackage{~theme~.theme}}{}
    \IfFileExists{~institute~.theme.sty}{\RequirePackage{~institute~.theme}}{}
}

\newcommand\metaline[2]{& #1 & #2 &\tabularnewline}

\newcommand\metas{
    \renewcommand\and{\par}
    \vspace{1cm}
    \begin{center}
        \begin{tabular}{p{1cm}rp{6cm}p{1cm}}
            \toprule
            \metaline{\textbf{Attribut}}{\textbf{Valeur}}
            \midrule
            \ifattr{version}{\metaline{Version}{~version~}}
            \ifattr{date}{\metaline{Date}{~date~}}
            \ifattr{author}{\metaline{Rédaction}{~author~}}
            \ifattr{validator}{\metaline{Validation}{~validator~}}
            \ifattr{history}{\metaline{Révisions}{~history~}}
            \bottomrule
        \end{tabular}
    \end{center}
    \vspace{1cm}
}

%% Counter
\setcounter{secnumdepth}{5} % On affiche une numérotation sur une profondeur de 5
\setcounter{tocdepth}{3}        % La table des matières va a une profondeur de 3

% Redefines (sub)paragraphs to behave more like sections
\ifx\paragraph\undefined\else
\let\oldparagraph\paragraph
\renewcommand{\paragraph}[1]{\oldparagraph{#1}\mbox{}}
\fi
\ifx\subparagraph\undefined\else
\let\oldsubparagraph\subparagraph
\renewcommand{\subparagraph}[1]{\oldsubparagraph{#1}\mbox{}}
\fi

\RequirePackage{dirtree}
\renewcommand*\DTstyle{\sffamily\small}
\renewcommand*\DTstylecomment{\texttt}
