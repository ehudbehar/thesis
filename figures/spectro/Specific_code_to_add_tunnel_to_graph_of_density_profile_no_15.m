%This code plots the plasma density profile over the capillary radius.
clear all;
%Beggining

%The exclusion boundaries for thursday 8.5kV are: 115-135 165-180 330-350. 
%PART A
Expletsbegin=(inputdlg('Hello there code user, I will be your host for today. This code will plot for you the plasma density profile of a meassurment of your choosing, all you need to do is answer my following questions. Are you ready to begin the journey? If so type 1 if not type whats the gist physicist:'));
Expletsbegin=str2num(Expletsbegin{1});
if Expletsbegin==1
    %for the sake of the loop, predetermine the rows to examine.
        firstCline=[];
        secondCline=[];
        thirdCline=[];
        Explowcut=50;
        Exphighcut=150;

    %Choosing the file you want to analyze (make sure the file name doen not beggin with a '0', also you may need to change the file path). 
    %You may choose to cut some of the rows at first, then you may choose 2 domains (of columns) to
    %exclude at the fitting proccess.
%     Expnumber=(inputdlg('What is the fit file name, good sir?'));
%     Expnumber=str2num(Expnumber{1});
        i=15;
        for Expnumber=i
        
            Data=fitsread(['C:\Users\user1\Desktop\School\HIL\PlasmaDensityAnalysis\17.06\binning2\',num2str(Expnumber),'.fit']);
%     Explowcut=(inputdlg('Cool, now tell me from which row would you like to begin your analysis?'));
%     Explowcut=str2num(Explowcut{1});
%     Exphighcut=(inputdlg('You are one crazy lad, so now tell me at which row would you like to end your analysis?'));
%     Exphighcut=str2num(Exphighcut{1});
%     Expexcludemin1=(inputdlg('Now lets exclude some carbon losers! For the first carbon line what is the minimum column you would like do exclude?'));
%     Expexcludemin1=str2num(Expexcludemin1{1});
%     Expexcludemax1=(inputdlg('OK and what is the next column? keep in mind that all of the columns inbetween those two will be excluded'));
%     Expexcludemax1=str2num(Expexcludemax1{1});
%     Expexcludemin2=(inputdlg('Now we do the same but for a different carbon line, so again what is the minimum column of the second line?'));
%     Expexcludemin2=str2num(Expexcludemin2{1});
%     Expexcludemax2=(inputdlg('Toit! and what is the maximum column of that same line? and blessed be the fruit'));
%     Expexcludemax2=str2num(Expexcludemax2{1});
%     Expexcludemin3=(inputdlg('Last but not least, the minimum of the third line is.........?'));
%     Expexcludemin3=str2num(Expexcludemin3{1});
%     Expexcludemax3=(inputdlg('And its maximum will be contestant number (drum rolls)? May the lord open'));
%     Expexcludemax3=str2num(Expexcludemax3{1});
%     firstCline=[Expexcludemin1:Expexcludemax1];
%     secondCline=[Expexcludemin2:Expexcludemax2];
%     thirdCline=[Expexcludemin3:Expexcludemax3];

    
%PART B
    
    %Setting up the system parameters for further calculations & opening needed
    %arrays. Attention!! see that those parameters fit the experimental setup. (we use here um units). 
        [M,N]=size(Data); x=linspace(1,N,N);
        capillaryradius=500; magnification=5; ICCDhieght=14*10^3;numofpixels_y=M; binning=2; 
        umperpixel=ceil(ICCDhieght/numofpixels_y); Parametersmatrix=[]; FWHM_error=[];
    %cop stands for center of plasma.
        copinpixel=124; copinum=copinpixel*umperpixel; %NOTE!! these two are not the real ones, we need to check it in the lab.
    %Here is where your data partitioning takes place.
        partialdata=Data(Explowcut:Exphighcut,:);
    %Determine how many rows do you want to put in the smaller matrix (for fit finding).
        row=1;
    %Fit each and every matrix (in the case of row=1, it is proccessing
    %rows and not matrices per se.
        grp=size(partialdata,1)/row;
        for k=1:grp
            idr=(1:row)+(k-1)*row;
            smallmatrix=partialdata(idr,:); %Here we recieved a small matrix which rows dimensions were dicided by row earlier.
    %Now we want to find the fit for that matrix.
    %Preparing the data for fitting, this will help recognizing whether the
    %data is ready to be used into fit creation.
            [Xdata, Ydata] = prepareCurveData( x, smallmatrix );
    %Determine the function you want to fit to the data.
            ft = fittype( 'A^2/((x-x0)^2+g^2)+d', 'independent', 'x', 'dependent', 'y' );
    %Here the exclusion takes place.
            excludedpoints=excludedata(Xdata, Ydata, 'indices', [firstCline secondCline thirdCline]);
    %Choose your parameters. Note that the size of the opts. matrices should be the
    %size of the constants you put in the function equation.
    %Note!!  the parameters of the fit matrix is organized ALPHABETICALLY
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [-Inf -Inf 10 150];
            opts.StartPoint = [1 0 0.0975 0.2785];
            opts.Upper = [Inf Inf 400 220];
            opts.Exclude = excludedpoints;
    %Create the fit! & the parameters matrix.
            [fitresult, gof] = fit( Xdata, Ydata, ft, opts );
            parameters=coeffvalues(fitresult);
            Parametersmatrix=[Parametersmatrix;parameters];
            coefferror=confint(fitresult,0.95);
            FWHM_error=[FWHM_error coefferror(:,3)];

        end
    
    
%PART C
   %Calculating FWHM errorbar.
        Dlambda_error=abs(FWHM_error(2,:)-FWHM_error(1,:))./4;
       %Extracting the full width half maximum (FWHM) for all of the fits.
        FWHM=2.*Parametersmatrix(:,3);
       %Switching to nm unit.
        Dlambda=FWHM.*0.089;
       %Switching from FWHM to plasma density
        n_e=(Dlambda./5.4).^(3/2);
       %Switching from pixel to distance from center
        radius=(0:umperpixel:ICCDhieght);
        centeredradius=radius(Explowcut+1:Exphighcut+1)-copinum;
        realcop=centeredradius./magnification;
       %Error for density
        n_error=(Dlambda_error./5.4).^(3/2);
       %Plot
        h=figure ('Name', ['Density Profile of meassurment: ',num2str(Expnumber)]);
        the_plot=plot(realcop,n_e','.','MarkerSize',10);
        errorbar(realcop,n_e',n_error,'.','MarkerSize',10,'CapSize',6,'Color',[0.87, 0.49, 0],'MarkerEdgeColor', 'black')
       %Labels & axes
        title ('Plasma density vs. radius')
        xticks(-250:50:250)
        yticks(0:0.1:1)
        axis([-250 250 0 1])
        grid on
        hold on
        
       %Fitting the deep profile.
        x_axis=realcop(66:73);
        y_axis=n_e(66:73);
        [Xdata1, Ydata1] = prepareCurveData(x_axis, y_axis );
        ft1 = fittype( 'a*(x-x_1)^2+b', 'independent', 'x', 'dependent', 'y' );
        f = fit( Xdata1, Ydata1, ft1);
        hollow_profile=plot(f,'b');
        legend([hollow_profile], {'Fitted f\proptor^2 function'}, 'Location' ,'SouthEast')
        xlabel ('Radius(um)')
        ylabel ('Plasma density (10^1^8 cm^-^3)')
        
        
        
       %Saving the figure.
%         filename1=['Density Profile of meassurment ',num2str(Expnumber)];
%         saveas(h,filename1,'jpeg');
%        %Saving what I considered as relevant data.
%         filename2=['Data of ',num2str(Expnumber),'.mat'];
%         save(filename2, 'n_e', 'Parametersmatrix', 'n_error');
        end
        
else 
    disp('QUIT BEING A LAZY ASS AND GET BACK TO WORK!!!');
    
end

