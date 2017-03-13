classdef Printer
    %PRINTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Access = public)
        function print_sim_start(obj)
            fprintf('\t=== Start of simulation config A ===\n');
        end
        
        function print_sim_end(obj)
            fprintf('\t=== End of simulation ===\n');
        end
        
        function print_save_result(obj, folder_name)
            fprintf('\n\tresults are stored in the folder: ''%s''\n', folder_name);
        end
        
        function print_end(obj)
            fprintf('\n\t=== End ===\n');
        end
    end
    
end

