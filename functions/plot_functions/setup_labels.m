function setup_labels( handle, title_label, x_label, y_label )
%SETUP_LABELS Summary of this function goes here
%   Detailed explanation goes here

    xlabel(handle, x_label, 'interpreter', 'latex','FontSize', 15);
    ylabel(handle, y_label, 'interpreter', 'latex','FontSize', 15);
    title(handle, title_label,'FontSize', 15);  
end

