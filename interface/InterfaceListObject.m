classdef InterfaceListObject < Interface_List
   
    %%
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = InterfaceListObject(name)
            % InterfaceListObject  Constructor. Do not call this constructor directly.
            %                       use InterfaceImdsForCNNWithTest
            %                       or InterfaceImdsForCNNW
            %                       or InterfaceImage
            
           % obj = obj@Interface_List();
            
            try
                obj=obj.setName(name);
                obj=obj.setKind('InterfaceListObject');
                obj.listObject=[];
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
        function obj = addObject(obj, object)
            try
              %  obj.setURI(object.URI);
                tmp=object.interfaceOut;
                
                tms=[];
                atms=[];
                
                for operat=object.owner.getLstOperations
                    tms=[tms,struct('operationName', operat{1}.algo, 'time',operat{1}.times(end))];
                    atms=[atms,operat{1}.times(end)];
                end
                
                try
                    %if operation of pipe
                    tmp = setfield(tmp,'times',tms);
                catch
                    %if pipe of pipe
                    try
                    obj.times=[obj.times; tms.time];
                    catch
                    end
                end
                
                try
                 tmp=tmp.simplyfyResult;
                 if isstruct(tmp)
                     tmp = setfield(tmp,'times',atms);
                 end
                catch
                end
                
                if (isa(tmp,'single')||isa(tmp,'double')||isa(tmp,'int8')||isa(tmp,'int16')||...      
                    isa(tmp,'int32')||isa(tmp,'int64')||isa(tmp,'uint8')||isa(tmp,'uint16')||...
                    isa(tmp,'uint32')||isa(tmp,'uint64')||isa(tmp,'logical')||isa(tmp,'char')||...
                    isa(tmp,'string')||isa(tmp,'struct')||isa(tmp,'cell')||isa(tmp,'table'))
                    
                    obj.listObject=[obj.listObject; tmp];
                    
                else
                    obj.listObject=[obj.listObject; InterfaceObject(obj.name ,tmp)];
                end
                
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

