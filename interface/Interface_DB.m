classdef (Abstract) Interface_DB < Interface_Value
    
    %%
    properties(SetAccess = protected)
        imdsValidation=[];
        imdsTest=[];
        imdsTrain=[];
        path_=[];
        
    end
    
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Interface_DB(path_, prcTrain, prcValidation)
            % Interface_Value  Constructor. Do not call this constructor directly.
            %                       use InterfaceImdsForCNNWithTest
            %                       or InterfaceImdsForCNNW
            %                       or InterfaceImage
            
            try
                obj.type='Interface_DB';
                obj.path_=path_;
                
                if length(path_)>0
                    try
                        [obj.imdsTrain,obj.imdsValidation,obj.imdsTest] = distribution(path_, prcValidation, prcTrain);
                    catch
                        [obj.imdsTrain,obj.imdsValidation] = distribution(path_, prcValidation, prcTrain);
                    end
                end
                
            catch
            end
            
            end
        
         %%
        function output = addAtURI(obj)
  
            output=strcat('\',obj.URI);
            
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    
end


