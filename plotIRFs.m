function plotIRFs(IRFs,ub,lb,h,which_shock, names, varnames, which_ID_strat, print_figs)
    % h = IR horizon for figures
    % ub and lb are the bootstrapped CI
    % names = cell vector of shock names
    % varnames = cell vector of variable names
    % which_ID_strat = a string describing which identification strategy we used
    % print_figs = 'yes' --> saves the figures; else if 'no' -- > just
    % shows the figures.
    
    nvar = size(IRFs,1);
    nshocks = size(which_shock,2);
    periods = 1:h;
    
    for i_shock=1:nshocks
        name = names{i_shock};
        
        % Draw pretty pictures
        figure(i_shock)
        set(gcf,'color','w'); % sets white background color
        set(gcf, 'Position', get(0, 'Screensize')); % sets the figure fullscreen (hopefully)
        for i_var=1:nvar
            varname = varnames{i_var};
            subplot(nvar,1,i_var)
            hold on
            plot(periods,IRFs(i_var,1:h,which_shock(i_shock)),'linewidth',1.5,'Color','r')
            plot(periods,ub(i_var,1:h,which_shock(i_shock)),'--','linewidth',1,'Color','k')
            plot(periods,lb(i_var,1:h,which_shock(i_shock)),'--','linewidth',1,'Color','k')
            plot(zeros(1,h), 'Color','b')
            title([name, ' on ' , varname])
            hold off
            grid on
        end
        
        % Save figures if you want to
        if strcmp(print_figs, 'yes')
            invoke_export_fig(name, which_ID_strat)
            close all
        end
    end