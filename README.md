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

### Notes on "typical ccd image"
I generated the color 2d plot using matlab and the following lines of code:
```matlab
[X, Y] = meshgrid(linspace(1,1024,100)...
                 ,linspace(1,256,100) ); % generate a rectangle maeshgrid
A=10;
b=0.0008; % gausiian width
c=90;
F = ...
(A./((X-512).^2+100000)).*(exp(-b.*((Y-c).^2))+exp(-b.*((Y-c-65).^2)));
surf(X,Y,F)
xlabel('lambda')
ylabel('Y')
view(2)
```
The function that displays the density profile is
![Equation](https://i.ibb.co/RbssSnx/png.png) i.e., addition of two Gaussians in the spatial coordinate and a Lorentzian in the wavelength coordinate.
