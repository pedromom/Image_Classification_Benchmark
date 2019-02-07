classdef (Abstract) Interface_Value < Interface
    
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Interface_Value()
            % Interface_Value  Constructor. Do not call this constructor directly.
            %                       use InterfaceImdsForCNNWithTest
            %                       or InterfaceImdsForCNNW
            %                       or InterfaceImage
            
            try
                obj.type='Interface_Value';
            catch
            end
            
        end
        
        %%
        function output = addAtURI(obj)
            output='';
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    end
    
end


