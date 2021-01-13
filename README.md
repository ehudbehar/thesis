# M. Sc. thesis, written in LaTeX

## Notes about customizing Tufte-style
The tufte-handout document class doesn't support part and chapters heading levels. As it is now, (23-Nov) I don't knnow how to change it so it does.

Euther way, I did find I way to customize the the definitions of the tufte-handout document:
Download the files `tufte-book.cls`, `tufte-common.def`,`tufte-handout.cls` and `tufte.bst` to your project. Suppose the files are located in the following structure:
```
project
│   main.tex
│   latexmkrc     
└───figures
│   │   figure01.png
│   │   figure02.png
└───template
│   └───Tufte
│       │   tufte-book.cls
│       │   tufte-common.def
│       │   tufte-handout.cls
│       │   tufte.bst
```

Then, create a [latexmkrc](https://www.overleaf.com/learn/latex/Questions/I%20have%20a%20lot%20of%20.cls,%20.sty,%20.bst%20files,%20and%20I%20want%20to%20put%20them%20in%20a%20folder%20to%20keep%20my%20project%20uncluttered.%20But%20my%20project%20is%20not%20finding%20them%20to%20compile%20correctly) file and locate it at the root folder.

write this into the file:
```
$ENV{'TEXINPUTS'}='./template/Tufte//:' . $ENV{'TEXINPUTS'};
$ENV{'BSTINPUTS'}='./template/Tufte//:' . $ENV{'BSTINPUTS'};
```
Any changes made to theses four installation files will be updated to the compiler, but only if the file is a tufte-handout file. As far as I know, this doesn't work for the tufte-book document class.

The relevant changes I made are:
 - Customize headings. `tufte-common.def`, lines 1613-1643, after this [answer](https://tex.stackexchange.com/a/96125) and this [page](https://www.overleaf.com/learn/latex/Sections_and_chapters#Customize_chapters_and_sections). I also posted a question [here](https://latex.org/forum/viewtopic.php?f=48&t=33875).
 - Turn on [section numbering](https://www.overleaf.com/learn/latex/Sections_and_chapters#Document_Sectioning), line 495 in the same file. Add this to the document preamble:
 ```
 % Turn on section numbering
\usepackage{titlesec}
\setcounter{secnumdepth}{2}
 ```

The easier way is to make the changes in the document pre-amble, and not to touch the metal, or to create a file with the defintion and load it explicitly with that method.

### Document class options and macro preamble:
- `nofonts`: Use Computer Modern Font, not the the tufte default.
- `justified`: Text alignment as in print media (align both the left and right ends of consecutive lines of text).
- `nobib`: Prevents tufte-book from loading `natbib`, which means you should load `biblatex` or `bibtex`.
- `openany`: Remove an unwanted blank page between two chapters.
- Turn on section numbering and set the depth to which section numbering occurs (chapters onwards): `\setcounter{secnumdepth}{2}`.
- Load the `titlesec` package to customize chapters, sections and subsections style: `\usepackage{titlesec}`.
Sections style and format:
```tex
% chapter format
\titleformat{\chapter}%
  {\huge\sffamily\bfseries}% format applied to label+text
  {\llap{\colorbox{cyan}{\parbox{1.5cm}{\hfill\itshape\huge\color{white}\thechapter}}}}% label
  {2pt}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
% section format
\titleformat{\section}%
  {\sffamily\Large\bfseries}% format applied to label+text
  {\thesection}% label
  {1 em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
% subsection format
\titleformat{\subsection}%
  {\sffamily\large}% format applied to label+text
  {\thesubsection}% label
  {4 pt}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
```

- Add links to `ref`s:
```tex
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=cyan,
    filecolor=magenta,
    pdftitle={Ehud Behar M.Sc. thesis}
}
```


### Notes on "typical ccd image"
I generated the color 2d plot using matlab and the following lines of code:
```matlab
[X, Y] = meshgrid(linspace(1,1024,100)...
                 ,linspace(1,256,100) ); % generate a rectangle maeshgrid
A=10;
b=0.0008; % gausiian width
c=90;
F = ...
(A./((X-512).^2+100000)).*(exp(-b.*((Y-c).^2))+exp(-b.*((Y-c-60).^2)));
surf(X,Y,F)
xlabel('lambda')
ylabel('Y')
view(2)
xlim([1 1024])
ylim([0 256])
pbaspect([4 1 1])
axis off;
set(gca,'Position',[0 0 1 1]);
saveas(gcf,'typical_image.png')
```
The function that displays the density profile is
![Equation](https://i.ibb.co/RbssSnx/png.png) i.e., addition of two Gaussians in the spatial coordinate and a Lorentzian in the wavelength coordinate.

### Capillaries 3D figures
Generated with Mathematica, using the following code:
```mathematica
capillary = Grid[{Table[
    Import[
     "C:\\Users\\HILL\\Desktop\\stright caillary wih gas inlet - \
50_05.STL", "Graphics3D"
     , ImageSize -> 960
     , ViewAngle -> All
     , Lighting -> Automatic
     , ViewVertical -> {0, 1, 0}
     , ViewPoint -> j]
    , {j, {{1, 0, 0}, {0, 0, 1}, {2, 0, 2}, {1.2, 0.9, 2.3}}}]
   }]
Export["C:\\LOCATION-PATH\\capillary_cad.pdf", capillary]

doubecapillary = 
 Grid[{Table[
    Import["C:\\Users\\HILL\\Desktop\\DC_500_500_90.STL", 
     "Graphics3D", ImageSize -> 240, ViewAngle -> All, 
     Lighting -> Automatic, ViewVertical -> {0, 1, 0}, 
     ViewPoint -> 
      j], {j, {{-1, 0, 0}, {0, 0, -1}, {-2, 0, -2}, {-1.2, 2, 
       2.3}}}]}]
```

### Longitudinal profile
```mathematica
average = 0.27;
c = 0.01;
ListPlot[{average +
   RandomFunction[
    WhiteNoiseProcess[LaplaceDistribution[0, c]]
    , {0, 500}
    ]
  , {{0, average}, {500, average}}}
 , Joined -> True(*,Filling\[Rule]Axis*),
 PlotRange -> {0, average + 5 c}]
```

## Double Capillary
On December 30th 2020 I finally succeeded measuring the 800nm signal when making a discharge. Arie said to put an iris in front of the convex lens positioned in the vacuum chamber. The iris was opened to ~4mm in diameter, and the bump of the optical noise was downgraded to ~35 mV, instead of 80 or 60 without. The bump's amplitude depends strongly on the capillary discharge strength; bright plasma -> high bump.

Unfortunately, only the left branch is (probably) amplified. The right one is not affected at all. And the left channel was connected to the power supply.

When connecting the second power supply, the current profile of the first looks not as good as before, and the current profile of the second (Rogowsky II) is not critical damped. Additionaly, the bump of the optic noise is has a different shape, and additional electric noises are visible.
