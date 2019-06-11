\DeclareCurrentRelease{}{2018/07/12}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csusexam}%
[2018/07/12 Exam class CS and IA Department at Universidad de Sevilla]

\LoadClassWithOptions{memoir}

% Load required packages
\RequirePackage{xparse}
\RequirePackage{expl3}
\RequirePackage{tcolorbox}
\RequirePackage{xsim}

% Page geometry
\semiisopage[15]
\checkandfixthelayout

% Page style
\makepagestyle{csusex@pagestyle}
\makeoddfoot{csusex@pagestyle}{}{\thepage{} de \thelastpage}{}
\makeevenfoot{csusex@pagestyle}{}{\thepage{} de \thelastpage}{}
\pagestyle{csusex@pagestyle}

% Exam setup
\ExplSyntaxOn

\keys_define:nn{csusexam}{
  asignatura     .tl_set:N = \csusex@subject,
  convocatoria   .tl_set:N = \csusex@examperiod,
  titulación     .tl_set:N = \csusex@degree,
  examen         .tl_set:N = \csusex@exam,
  fecha          .tl_set:N = \csusex@date,
  con-soluciones .bool_set:N = \csusex@withsolutions,
  subject        .tl_set:N = \csusex@subject,
  examperiod     .tl_set:N = \csusex@examperiod,
  degree         .tl_set:N = \csusex@degree,
  exam           .tl_set:N = \csusex@exam,
  date           .tl_set:N = \csusex@date,
  with-solutions .bool_set:N = \csusex@withsolutions,
}

\ProvideDocumentCommand{\csusex@examsetup}{m}{\keys_set:nn{csusexam}{#1}}
\ProvideDocumentCommand{\configuraciónexamen}{}{\csusex@examsetup}
\ProvideDocumentCommand{\examsetup}{}{\csusex@examsetup}

\ExplSyntaxOff

% Header
\tcbuselibrary{skins}
\newtcolorbox{csusex@header}{
  every box on layer 2/.style={
    reset,
    colback=white,
    frame empty,
    sidebyside,
    sidebyside align=top,
    flushleft upper,
    flushright lower,
    lower separated=false,
    boxsep=0pt,
    nobeforeafter,
  },
  enhanced,
  colback=white,
  drop lifted shadow,
  fontupper=\scshape,
  center upper,
  before upper={%
    \begin{tcolorbox}
      \csusex@subject
      \tcblower
      \csusex@examperiod
    \end{tcolorbox}
    \begin{tcolorbox}[before skip=-.2cm]
      \csusex@degree
      \tcblower
      \csusex@exam
    \end{tcolorbox}
    \csusex@date
    \par
    \bigskip
  },
  after={%
    \par
    \bigskip
  },
}
\ProvideDocumentEnvironment{cabeceraexamen}{}{%
  \begin{csusex@header}\ignorespaces
}{%
  \end{csusex@header}\ignorespacesafterend
}
\ProvideDocumentEnvironment{examheader}{}{%
  \begin{csusex@header}\ignorespaces
}{%
  \end{csusex@header}\ignorespacesafterend
}

% Ellipsis
\ProvideDocumentCommand{\csusex@ellipsis}{O{1em}}{\rule[-.25ex]{#1}{1pt}}
\ProvideDocumentCommand{\elipsis}{}{\csusex@ellipsis}
\ProvideDocumentCommand{\ellipsis}{}{\csusex@ellipsis}
\ProvideDocumentCommand{\csusex@ellipsisfill}{}{\cleaders\hbox{\csusex@ellipsis}\hfill\null}
\ProvideDocumentCommand{\elipsiscompleta}{}{\csusex@ellipsisfill}
\ProvideDocumentCommand{\ellipsisfill}{}{\csusex@ellipsisfill}

% Exercises
\DeclareExerciseTranslation{spanish}{exercise}{ejercicio}
\DeclareExerciseTranslation{spanish}{solution}{solución}
\DeclareExerciseTranslation{spanish}{point}{punto}
\DeclareExerciseTranslation{spanish}{points}{puntos}

\DeclareExerciseEnvironmentTemplate{csusex@template}{%
  \noindent
  {\bfseries\XSIMmixedcase{\GetExerciseName}~\GetExerciseProperty{counter}}
  \IfInsideSolutionF{%
    \,\GetExercisePropertyT{subtitle}{\PropertyValue}
    \enspace\GetExercisePropertyT{points}{(\emph{\points{\PropertyValue}})}
  }
  \begin{list}{}{\setlength{\leftmargin}{1em}}
    \item
}{%
  \end{list}
}

\xsimsetup{
  exercise/template=csusex@template,
  solution/template=csusex@template,
}

\DeclareExerciseType{ejercicio}{
  exercise-env=ejercicio,
  solution-env=solución,
  exercise-name=\XSIMtranslate{exercise},
  solution-name=\XSIMtranslate{solution},
  exercise-template=csusex@template,
  solution-template=csusex@template,
}

\DeclareExerciseProperty{subtítulo}
\DeclareExerciseProperty{puntos}
\DeclareExercisePropertyAlias{subtitle}{subtítulo}
\DeclareExercisePropertyAlias{points}{puntos}

\ExplSyntaxOn

\DeclareExerciseCollection{csusexam}
\NewDocumentEnvironment{csusex@examexercises}{}{%
  \collectexercises{csusexam}
}{%
  \collectexercisesstop{csusexam}
  \bool_if:NTF \csusex@withsolutions {%
    \printcollection[print=both]{csusexam}
  }{%
    \printcollection{csusexam}
  }
}
\NewDocumentEnvironment{ejerciciosdelexamen}{}{%
  \begin{csusex@examexercises}
}{%
  \end{csusex@examexercises}
}
\NewDocumentEnvironment{examexercises}{}{%
  \begin{csusex@examexercises}
}{%
  \end{csusex@examexercises}
}

\NewDocumentCommand{\csusex@inputexercise}{om}{%
  \input{#2}
  \IfValueT{#1}{\SetExerciseProperty{puntos}{#1}}
}
\NewDocumentCommand{\incluyeejercicio}{}{\csusex@inputexercise}
\NewDocumentCommand{\inputexercise}{}{\csusex@inputexercise}

\ExplSyntaxOff
