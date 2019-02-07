classdef (Abstract) Interface_List < Interface
    
    properties (SetAccess = protected)
        times;
        listObject=[];
    end
    
    methods
               
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Interface_List()
            % Interface_List  Constructor. Do not call this constructor directly.
            %                       use InterfaceImdsForCNNWithTest
            %                       or InterfaceImdsForCNNW
            %                       or InterfaceImage
            
            try
                obj.type='Interface_List';
            catch
            end
        end
       
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    
end


