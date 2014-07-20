function MP2_4203627
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program starts with a default plot of a Sin, Cos and the sum of those
% two waves plotted to the axes. The user can then change the frequency and 
% amplitude using the options panel and can also choose to plot the wave in 
% 3D, pause it, play it again or record a short avi of it. The 'exit safely'
% button cleans up any running animations before exiting to avoid errors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Window

% create figure window 'fig' using structure 'h' at [xpos, ypos, xdim, ydim]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    h.fig = figure('position', [50 50 800 600], 'HandleVisibility', 'on',...
        'NumberTitle', 'off', 'Name', 'Happy Wave Generator', 'color', 'white'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Axes

% create axes to view the program output, with the figure (handle 'fig') as 
% a parent with position of [x, y, dimx, dimy] relative to fig. If the
% plots to these axes then control the axes with nextplot, allowing them to
% reset and therefore display the data properly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    h.ax1 = axes('parent', h.fig, 'Position', [0.05 0.75 .6 .2],...
            'NextPlot', 'replace', 'HandleVisibility', 'on');

    h.ax2 = axes('parent', h.fig, 'Position', [0.05 0.5 .6 .2],...
            'NextPlot', 'replace', 'HandleVisibility', 'on'); 

    h.ax3 = axes('parent', h.fig, 'Position', [0.05 0.05 .6 .4],...
            'NextPlot', 'replace', 'HandleVisibility', 'on');  

    %for use in button callbacks

    global f a %make them global so the other functions can update them directly without passing
    
    f = 4;%frequency
    a = 2;%amplitude

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial 2D Panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    h.pan2D = uipanel('Parent', h.fig, 'Title', '2D options','Position',...
                                                    [.7 .6 .25 .3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % create a button that will change the display from a 2D plot to a 3D surf
    h.threeD = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', '3D', 'position',...
                                                    [50 100 100 30]);
    % this is reversed in the callback

    % create the button to increase f
    h.fInc = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'f++', 'position',...
                                                    [100 50 50 30]);
    % create the button to decrease f
    h.fDec = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'f--', 'position',...
                                                    [50 50 50 30]);
    % create the button to increase A
    h.aInc = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'A++', 'position',...
                                                    [100 20 50 30]);
    % create the button to decrease A
    h.aDec = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'A--', 'position',...
                                                    [50 20 50 30]);

    % set button callbacks
    set(h.threeD, 'callback', {@doThreeD,h});
    set(h.fInc,'callback', {@incF2D,h});
    set(h.fDec, 'callback', {@decF2D,h});
    set(h.aInc,'callback', {@incA2D,h});
    set(h.aDec, 'callback', {@decA2D,h});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% other options panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    h.panOps = uipanel('Parent', h.fig, 'Title', 'Other Options', 'position',  [.7 .05 .25 .3]);
    h.exitSaf = uicontrol('style', 'pushbutton', 'parent', h.panOps,'String', 'Exit Safely', 'position',...
                                                    [50 110 100 30]);
    h.pauseWav = uicontrol('style', 'pushbutton', 'parent', h.panOps,'String', 'Pause', 'position',...
                                                    [50 80 100 30]);
    h.playWav = uicontrol('style', 'pushbutton', 'parent', h.panOps,'String', 'Play', 'position',...
                                                    [50 50 100 30]); 
    h.recWav = uicontrol('style', 'pushbutton', 'parent', h.panOps,'String', 'Record 10s', 'position',...
                                                    [50 20 100 30]);  
    
    %callbacks for the other options panel buttons
    set(h.exitSaf, 'callback', {@ex,h});
    set(h.pauseWav, 'callback', {@wavPause,h});
    set(h.playWav, 'callback', {@wavPlay,h});
    set(h.recWav, 'callback', {@wavRec,h});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     initWavGen2D(h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set callbacks and button behaviour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function h = doTwoD(hObject, eventdata,h)
        
    global flag
    
    flag = 0; % stop the animation
    
    % delete 3D panel
    delete(h.pan3D);
    h = rmfield(h, 'pan3D');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Panel if switched back from the 3D panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    h.pan2D = uipanel('Parent', h.fig, 'Title', '2D options','Position',...
                                                    [.7 .6 .25 .3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % create a button that will change the display from a 2D plot to a 3D surf
    h.threeD = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', '3D', 'position',...
                                                    [50 100 100 30]);
    % this is reversed in the callback

    % create the button to increase f
    h.fInc = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'f++', 'position',...
                                                    [100 50 50 30]);
    % create the button to decrease f
    h.fDec = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'f--', 'position',...
                                                    [50 50 50 30]);
    % create the button to increase A
    h.aInc = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'A++', 'position',...
                                                    [100 20 50 30]);
    % create the button to decrease A
    h.aDec = uicontrol('style', 'pushbutton','Parent', h.pan2D, 'String', 'A--', 'position',...
                                                    [50 20 50 30]);
    % set button callbacks
    set(h.threeD, 'callback', {@doThreeD, h});
    set(h.fInc,'callback', {@incF2D,h});
    set(h.fDec, 'callback', {@decF2D, h});
    set(h.aInc,'callback', {@incA2D, h});
    set(h.aDec, 'callback', {@decA2D, h});

    initWavGen2D(h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3D Panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function h = doThreeD(hObject, eventdata, h)
    global flag
    
    flag = 0; % stop the animation

    %delete the 2D panel
    delete(h.pan2D);
    h = rmfield(h, 'pan2D');

    % create a panel for any buttons to go on with the parent fig and position
    % relative to fig.
    h.pan3D = uipanel('Parent', h.fig, 'Title', '3D options','Position',...
                                                    [.7 .6 .25 .3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % create a button that will change the display from a 3D plot to a 2D surf
    h.twoD = uicontrol('style', 'pushbutton','Parent', h.pan3D, 'String', '2D', 'position',...
                                                    [50 100 100 30]);
    % this is reversed in the callback

    % create the button to increase f
    h.fInc = uicontrol('style', 'pushbutton','Parent', h.pan3D, 'String', 'f++', 'position',...
                                                    [100 50 50 30]);
    % create the button to decrease f
    h.fDec = uicontrol('style', 'pushbutton','Parent', h.pan3D, 'String', 'f--', 'position',...
                                                    [50 50 50 30]);
    % create the button to increase A
    h.aInc = uicontrol('style', 'pushbutton','Parent', h.pan3D, 'String', 'A++', 'position',...
                                                    [100 20 50 30]);
    % create the button to decrease A
    h.aDec = uicontrol('style', 'pushbutton','Parent', h.pan3D, 'String', 'A--', 'position',...
                                                    [50 20 50 30]);

    % set button callbacks
    set(h.twoD, 'callback', {@doTwoD,h});
    set(h.fInc,'callback', {@incF3D,h});
    set(h.fDec, 'callback', {@decF3D,h});
    set(h.aInc,'callback', {@incA3D,h});
    set(h.aDec, 'callback', {@decA3D,h});

    initWavGen3D(h);

    function h = incF2D(hObject, eventdata, h)
        global f flag
        flag = 0; % stop the animation
        f = f+1;
        initWavGen2D(h);

    function h = decF2D(hObject, eventdata,h)
        global f flag
        flag = 0; % stop the animation
        f = f-1;
        initWavGen2D(h);

    function h = incA2D(hObject, eventdata, h)
        global a flag
        flag = 0; % stop the animation
        a = a+1;
        initWavGen2D(h);

    function h = decA2D(hObject, eventdata, h)
        global a flag
        flag = 0; % stop the animation
        a = a-1;
        initWavGen2D(h);

    function h = incF3D(hObject, eventdata, h)
        global f flag
        flag = 0; % stop the animation
        f = f+1;
        initWavGen3D(h);

    function h = decF3D(hObject, eventdata, h)
        global f flag
        flag = 0; % stop the animation
        f = f-1;
        initWavGen3D(h);

    function h = incA3D(hObject, eventdata, h)
        global a flag
        flag = 0; % stop the animation
        a = a+1;
        initWavGen3D(h);

    function h = decA3D(hObject, eventdata, h)
        global a flag
        flag = 0; % stop the animation
        a = a-1;
        initWavGen3D(h);

    %other options functions
        
    function h = ex(hObject, eventdata, h)
        global flag
        flag = 0;
        uiwait(msgbox('byebye!',':,(','modal'));
        close(h.fig);
        
    function h = wavPause(hObject, eventdata, h)
        global flag
        flag = 0;
       
    function h = wavPlay(hObject, eventdata, h)
        global typeFl
        
        if(typeFl == 1)
            initWavGen2D(h)
        elseif(typeFl ==-1)
            initWavGen3D(h)
        end
        
    function h = wavRec(hObject, eventdata, h)
        global typeFl
        global flag
        flag = 0;
        if(typeFl == 1)
            rec2D(h)
            initWavGen2D(h)
        else
            rec3D(h)
            initWavGen3D(h)
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wave plotting functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% plot 2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function h = initWavGen2D(h)
        global f a flag typeFl
        typeFl = 1;
        flag = 1;
        % sin cosine wave animation script
        
        
        nF = 100;               %number of frames
        T = 1/f;                %period
        w = 2*pi*f;             %omega (rotational speed)
        lambda = 1/4;           %wavelength
        v = f*lambda;           %wave speed
        

        t = linspace(0,T,nF);   %time
        x = t;                  %displacement
        i = 1;
        
        while(flag)

            yS = a.*sin(2.*pi.*f.*(t(i)-(x.*T)/lambda));        %sin wave

            yC = a.*cos((2.*pi.*(x/lambda))+(2.*pi.*f.*t(i)));  %cosine wave


            yR = yS + yC;           %sum of both waves

            %2D Plots
            axes(h.ax1);
            plot(t,yS);
            title('sin plot');
            axis([0,T,-a,a]);

            axes(h.ax2);
            plot(t,yC');
            title('cos plot');
            axis([0,T,-a,a]);

            axes(h.ax3);
            plot(t,yR);
            title('sum plot');
            axis([0,T,-3*a,3*a]);

            i = i+1;
            nF = nF + 1;
            t = linspace(0,T,nF);
            x = t;   

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% record 2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function h = rec2D(h)
     
        global f a flag typeFl
        typeFl = 1;
        flag = 1;
        % sin cosine wave animation script
        
        
        nF = 100;                %number of frames
        T = 1/f;                %period
        w = 2*pi*f;             %omega (rotational speed)
        lambda = 1/4;           %wavelength
        v = f*lambda;           %wave speed
        
        t = linspace(0,T,nF);   %time
        x = t;                  %displacement
        i = 1;
        t = linspace(0,T,nF);   %time
        x = t;                  %displacement
        vid2D = VideoWriter('wav2D.avi');
        open(vid2D);
        
        for i = 1:nF

            yS = a.*sin(2.*pi.*f.*(t(i)-(x.*T)/lambda));        %sin wave

            yC = a.*cos((2.*pi.*(x/lambda))+(2.*pi.*f.*t(i)));  %cosine wave


            yR = yS + yC;           %sum of both waves

            %2D Plots
            axes(h.ax1);
            plot(t,yS);
            title('sin plot');
            axis([0,T,-a,a]);

            axes(h.ax2);
            plot(t,yC');
            title('cos plot');
            axis([0,T,-a,a]);

            axes(h.ax3);
            plot(t,yR);
            title('sum plot');
            axis([0,T,-3*a,3*a]);

            F(i) = getframe;        %get the frame for the movie
            writeVideo(vid2D, F(i));
        end
        
        close(vid2D);
        nPlays = 1; 

        movie(F,nPlays); 
        
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% surf 3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function h = initWavGen3D(h)
        global f a flag typeFl
        typeFl = -1;
        flag = 1;
        %this script gets the variables and initalises a 3D plot

        nF = 50;                %number of frames
        T = 1/f;                %period
        w = 2*pi*f;             %omega (rotational speed)
        lambda = 1/4;           %wavelength
        v = f*lambda;           %speed of sound in air
        k = 2*pi/lambda;        %wave number
        t = linspace(0,T,nF);   %time
        x = t;                  %displacement
        y = x;                  %y for meshgrid  
        i = 1;
        [X,Y] = meshgrid(x,y);  %create the grid for  the surf plot

        while(flag)

            %3D plot
            axes(h.ax1);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z1);
            shading interp;         %choose colors at random

            axes(h.ax2);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z2);
            shading interp;         %choose colors at random

            axes(h.ax3);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z3);
            shading interp;         %choose colors at random
            
            nF = nF + 1;
            t = linspace(0,T,nF);   %time
            x = t;                  %displacement
            i = i+1;

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%record 3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function h = rec3D(h)
        global f a flag typeFl
        typeFl = -1;
        flag = 1;
        %this script gets the variables and initalises a 3D plot

        nF = 50;                %number of frames
        T = 1/f;                %period
        w = 2*pi*f;             %omega (rotational speed)
        lambda = 1/4;           %wavelength
        v = f*lambda;           %speed of sound in air
        k = 2*pi/lambda;        %wave number
        t = linspace(0,T,nF);   %time
        x = t;                  %displacement
        y = x;                  %y for meshgrid  
        i = 1;
        [X,Y] = meshgrid(x,y);  %create the grid for  the surf plot
        vid3D = VideoWriter('wav3D.avi');
        open(vid3D);
        
        for i = 1:nF

            %3D plot
            axes(h.ax1);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z1);
            shading interp;         %choose colors at random

            axes(h.ax2);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z2);
            shading interp;         %choose colors at random

            axes(h.ax3);
            R = sqrt(X.^2+Y.^2);
            Z1 = a.*sin(2.*pi.*f.*(t(i)+(R.*T)/lambda));        %sin wave
            Z2 = a.*cos((2.*pi.*(R/lambda))-(2.*pi.*f.*t(i)));  %cosine wave
            Z3 = Z1 + Z2;
            surf(X,Y,Z3);
            shading interp;         %choose colors at random

            F(i) = getframe;        %get the frame for the movie
            writeVideo(vid3D, F(i));
        end

        close(vid3D);
        nPlays = 1; 
        movie(F,nPlays);