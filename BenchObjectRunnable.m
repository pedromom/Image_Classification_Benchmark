classdef BenchObjectRunnable < BenchObject & handle
 
    %%
    properties (SetAccess = protected)
        %owner;
        interfaceIn;
        interfaceOut;
        algo;
        param;
        times=[];
    end
    
    %%
    methods
               
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = BenchObjectRunnable()
            % BenchObject  Constructor. Do not call this constructor directly.
           
            try   
                obj.type='BenchObjectRunnable';
            catch
            end
        end
      
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            %%
        function output = findBench(obj)
            
            try
                output = findBench(obj.owner);
            catch
                output = obj;
            end
            
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%
%         function output = getInterfaceIn(obj)
%             output = obj.interfaceIn;
%         end
% 
%           %%
%         function output = getInterfaceOut(obj)
%             output = obj.interfaceOut;
%         end
%         
        %%
        function obj = setInterfaceOut(obj, int)
            obj.interfaceOut=int;
        end
        %%
        function obj = setInterfaceIn(obj, int)
            try
            int.owner=obj;
            catch
            end
            obj.interfaceIn=int;
        end

          %%
        function obj = set.param(obj,val)
            obj.param = val;
        end
        
             %%
        function obj = set.times(obj, time)
            obj.times=time;
        end
        
             %%
        function obj = setTime(obj, time)
            obj.times=[obj.times, time];
        end
        
    end
    
end


