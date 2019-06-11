\DeclareRelease{}{2018/07/12}{csusexam-20180712.cls}
\DeclareCurrentRelease{}{2019/05/30}

\RequirePackage{expl3}
\ProvidesExplClass {csusexam} {2019/05/30} {}
{A class for writing exams at CS and IA Department of Universidad de Sevilla}

\LoadClassWithOptions{memoir}


% Load required packages
\RequirePackage{xparse}
\RequirePackage{tcolorbox}
\RequirePackage{xsim}


% Page geometry
\semiisopage[15]
\checkandfixthelayout


% Page style
\makepagestyle{csusex_pagestyle}
\makeoddfoot{csusex_pagestyle}{}{\thepage{}~de~\thelastpage}{}
\makeevenfoot{csusex_pagestyle}{}{\thepage{}~de~\thelastpage}{}
\pagestyle{csusex_pagestyle}


% Exam setup
\keys_define:nn{csusexam}{
  asignatura     .tl_set:N = \l__csusex_subject_tl,
  convocatoria   .tl_set:N = \l__csusex_examperiod_tl,
  titulación     .tl_set:N = \l__csusex_degree_tl,
  examen         .tl_set:N = \l__csusex_exam_tl,
  fecha          .tl_set:N = \l__csusex_date_tl,
  con~soluciones .bool_set:N = \l__csusex_withsolutions_bool,
  subject        .tl_set:N = \l__csusex_subject_tl,
  examperiod     .tl_set:N = \l__csusex_examperiod_tl,
  degree         .tl_set:N = \l__csusex_degree_tl,
  exam           .tl_set:N = \l__csusex_exam_tl,
  date           .tl_set:N = \l__csusex_date_tl,
  with~solutions .bool_set:N = \l__csusex_withsolutions_bool,
  puntos         .code:n = \SetExerciseProperty{puntos}{#1},
  points         .code:n = \SetExerciseProperty{points}{#1},
  iniciapágina   .code:n = \SetExerciseProperty{iniciapágina}{#1},
  startpage      .code:n = \SetExerciseProperty{startpage}{#1},
}

\cs_new:Nn \__csusex_examsetup:n
{
  \keys_set:nn{csusexam}{#1}
}

\ProvideDocumentCommand{\configuraciónexamen}{m}
{
  \__csusex_examsetup:n{#1}
}

\ProvideDocumentCommand{\examsetup}{m}
{
  \__csusex_examsetup:n{#1}
}


% Header
\tcbuselibrary{skins}
\newtcolorbox{csusex_header}{
  every~box~on~layer~2/.style={
    reset,
    colback=white,
    frame~empty,
    sidebyside,
    sidebyside~align=top,
    flushleft~upper,
    flushright~lower,
    lower~separated=false,
    boxsep=0pt,
    nobeforeafter,
  },
  enhanced,
  colback=white,
  drop~lifted~shadow,
  fontupper=\scshape,
  center~upper,
  before~upper={%
    \begin{tcolorbox}
      \l__csusex_subject_tl
      \tcblower
      \l__csusex_examperiod_tl
    \end{tcolorbox}
    \begin{tcolorbox}[before~skip=-.2cm]
      \l__csusex_degree_tl
      \tcblower
      \l__csusex_exam_tl
    \end{tcolorbox}
    \par
    \l__csusex_date_tl
    \par
    \bigskip
  },
  after={%
    \par
    \bigskip
  },
}

\ProvideDocumentEnvironment{cabeceraexamen}{}{%
  \begin{csusex_header}\ignorespaces
}{%
  \end{csusex_header}\ignorespacesafterend
}

\ProvideDocumentEnvironment{examheader}{}{%
  \begin{csusex_header}\ignorespaces
}{%
  \end{csusex_header}\ignorespacesafterend
}


% Ellipsis
\cs_new:Nn \__csusex_ellipsis:n
{
  \rule[-.25ex]{#1}{1pt}
}

\cs_new:Nn \__csusex_ellipsisfill:
{
  \cleaders\hbox{\__csusex_ellipsis:n{1em}}\hfill\null
}

\ProvideDocumentCommand{\elipsis}{O{1em}}
{
  \__csusex_ellipsis:n{#1}
}

\ProvideDocumentCommand{\ellipsis}{O{1em}}
{
  \__csusex_ellipsis:n{#1}
}

\ProvideDocumentCommand{\elipsiscompleta}{}
{
  \__csusex_ellipsisfill:
}

\ProvideDocumentCommand{\ellipsisfill}{}
{
  \__csusex_ellipsisfill:
}


% Exercises
\DeclareExerciseTranslation{spanish}{exercise}{ejercicio}
\DeclareExerciseTranslation{spanish}{solution}{solución}
\DeclareExerciseTranslation{spanish}{point}{punto}
\DeclareExerciseTranslation{spanish}{points}{puntos}

\DeclareExerciseEnvironmentTemplate{csusex_template}{%
  \IfInsideSolutionF{
    \IfExerciseBooleanPropertyT{startpage}{\newpage}
    \IfExerciseBooleanPropertyT{iniciapágina}{\newpage}
  }
  \noindent
  {\bfseries\XSIMmixedcase{\GetExerciseName}~\GetExerciseProperty{counter}}
  \IfInsideSolutionF{
    \,
    \GetExercisePropertyT{subtitle}{\PropertyValue}
    \GetExercisePropertyT{subtítulo}{\PropertyValue}
    \enspace
    \GetExercisePropertyT{points}{(\emph{\points{\PropertyValue}})}
    \GetExercisePropertyT{puntos}{(\emph{\points{\PropertyValue}})}
  }
  \begin{list}{}{\setlength{\leftmargin}{1em}}
    \item
}{
  \end{list}
}

\xsimsetup{
  exercise/template=csusex_template,
  solution/template=csusex_template,
}

\DeclareExerciseType{ejercicio}{
  exercise-env=ejercicio,
  solution-env=solución,
  exercise-name=\XSIMtranslate{exercise},
  solution-name=\XSIMtranslate{solution},
  exercise-template=csusex_template,
  solution-template=csusex_template,
}

\DeclareExerciseProperty{subtítulo}
\DeclareExerciseProperty{puntos}
\DeclareExerciseProperty*{startpage}
\DeclareExerciseProperty*{iniciapágina}

\DeclareExerciseCollection{csusexam}

\NewDocumentEnvironment{csusex_examexercises}{}
{
  \collectexercises{csusexam}
}
{
  \collectexercisesstop{csusexam}
  \bool_if:NTF \l__csusex_withsolutions_bool
  {
    \printcollection[print=both]{csusexam}
  }
  {
    \printcollection{csusexam}
  }
}

\NewDocumentEnvironment{ejerciciosdelexamen}{}
{
  \begin{csusex_examexercises}
}
{
  \end{csusex_examexercises}
}

\NewDocumentEnvironment{examexercises}{}
{
  \begin{csusex_examexercises}
}
{
  \end{csusex_examexercises}
}

\cs_new:Nn \__csusex_inputexercise:nn
{
  \group_begin:
  \input{#2}
  \IfValueT{#1}{\keys_set:nn{csusexam}{#1}}
  \group_end:
}

\NewDocumentCommand{\incluyeejercicio}{om}
{
  \__csusex_inputexercise:nn{#1}{#2}
}

\NewDocumentCommand{\inputexercise}{om}
{
  \__csusex_inputexercise:nn{#1}{#2}
}
