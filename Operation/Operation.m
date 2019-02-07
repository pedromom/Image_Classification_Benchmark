classdef Operation < BenchObjectRunnable & handle

    %%
    methods
        %%
        function obj = Operation(name)
           % Operation  Constructor. Do not call this constructor directly.
           
            try
                if exist('name','var')
                    obj=obj.setName(name);
                end
                obj.type='Operation';
            catch
                
            end
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function interface = makeFileName(obj, interface)
            
            try
                interfacen=interface.name;
                  
                try
                    tmp1=extractBefore (fliplr(interfacen),'.');
                    
                    if ~isempty(tmp1)
                        tmp1=extractAfter (fliplr(interfacen),'.');
                        tmp2=extractBefore (tmp1,'\');
                        tmp3=extractAfter (tmp1,'\');
                        tmp4=extractBefore (tmp3,'\');
                        tmp4=extractAfter (tmp4,'_');
                        tmp5=strcat(tmp2,'_',tmp4);
                        
                        try
                            interface.setName(fliplr(tmp5));
                        catch
                            interface=fliplr(tmp5);
                        end
                        
                    end
                    
                catch
                    warning('Problem in Operation:makeFileName.')
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
        
        %%
        function obj = setInterfaceOut(obj, interface)

            try
                
                %% seting interface fields
                try
                  %  interface.setURI(obj.interfaceIn.URI);
                    interface.setName(obj.interfaceIn.name);
                catch
                    try
                        try
                            interface = setfield(interface,'URI',obj.interfaceIn.URI);
                        catch
                            %Already exists
                        end
                        try
                            interface = setfield(interface,'name',obj.interfaceIn.name);
                        catch
                            %Already exists
                        end
                        
                    catch
                        warning('Problem in Operation:setInterfaceOut:setfields.');
                    end
                end
                
                %% managing output interface
                try
                    if ~isstruct(interface)
                        obj.interfaceOut=interface;
                    else
                        try
                            obj.interfaceOut=InterfaceObject(interface.name, interface);
                        catch
                            obj.interfaceOut=interface;
                        end
                    end
                catch
                    warning('Problem in Operation:setInterfaceOut:obj.interfaceOut.');
                end
            catch
                warning('Problem in Operation:setInterfaceOut.');
            end
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%                    Function Private                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%
    methods (Static)
        function obj = run(obj)
            
        end
    end
    
end

