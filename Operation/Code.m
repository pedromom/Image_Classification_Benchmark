classdef Code < Operation
    
    methods
        %%
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Code( name,kind,algo, prm, owner)
           % Code  Constructor. Do not call this constructor directly.
            
            try
                %% init code parameters
                
                obj.setName(name);
                obj.setKind(kind);
                
                if exist('prm','var')
                    obj.param=prm;
                else
                    obj.param=struct();
                end
                
                if exist('owner','var')
                    obj.owner=owner;
                else
                    obj.owner=[];
                end
                
                obj.algo=algo;
                
                %% URI (Uniform Resource Identifier) construction
                URI='';
                
                if ~strcmp(obj.owner.name, algo)
                    
                    URI=strcat(URI,algo);
                    
                    for k=fieldnames(obj.param)'
                        if ~(strcmp(k,'name'))
                            try
                                URI = strcat(URI,'_',k,'_',strrep(num2str(eval(char(strcat('obj.param.',k))))));
                            catch
                                URI =strcat(URI,'_',char(k),'_', num2str(eval(char(strcat('obj.param.',k)))));
                            end
                        end
                    end
                    
                end
                
                obj.URI=URI;
                
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
    
       %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    methods
        %%
        function obj = run(obj)
            
            try
                [fld,pth]=obj.manageIterfaceIn_;
                
                if ~fld
                    tElapsed = obj.process_;
                else
                    tElapsed=-1;
                end
                
                tElapsed=obj.manageIterfaceOut_(tElapsed,fld,pth);
                obj.setTime(tElapsed);
                
            catch
            end
        end
        
    
        
    end
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%                    Function Private                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%
    methods ( Access = private )
        
        %%
        function [fld,pth] = manageIterfaceIn_(obj)
            
            try
                fld=0;
                
                if ~strcmp(obj.algo,obj.owner.name)
                    
                    %It's an operation
                    try
                        
%                         %if it's àn interface
%                         try
%                             
%                             %with inteface of pipe
%                             if  isempty(obj.interfaceIn.URI)
%                                 obj.getInterfaceIn.setURI(strcat(obj.owner.URI,'\',obj.URI));
%                             else
%                                 obj.getInterfaceIn.setURI(strcat(obj.interfaceIn.URI,'\',obj.URI));
%                             end
%                             
%                         catch
%                             
%                             try
%                                 obj.setInterfaceIn(InterfaceObject(char(obj.getInterfaceIn), obj.getInterfaceIn));
%                                 obj.getInterfaceIn.setURI(obj);
%                             catch
%                                 obj.setInterfaceIn(InterfaceObject(obj.URI, obj.getInterfaceIn));
%                                 obj.getInterfaceIn.setURI(obj);
%                             end
%                             
%                         end
                        
                        % format the path
                        obj.makeFileName(obj.interfaceIn);
                        
                        % extract params
                        fieldNameBenchParam=fieldnames(obj.param);
                        
                        fltpm='';
                        
                        for fldn=fieldNameBenchParam'
                            if ~strcmp(fldn,'name')
                                fltpm = strcat(fltpm,char(fldn), num2str(eval(strcat('obj.param','.',char(fldn)))));
                            end
                        end
                        
                        % build path
                        pth=obj.findBench.curentPath;
                        if isempty(fltpm)
                            tmps=strcat(pth,'\',obj.algo);
                        else
                            tmps=strcat(pth,'\',obj.algo,'\',fltpm);
                        end
                        obj.findBench.setCurentPath(tmps);
                        
                        %
                        try
                            pth=strcat(tmps,'\',obj.interfaceIn.getFileName,'.mat');
                        catch
                            try
                                pth=strcat(tmps,'\',obj.interfaceIn.name,'.mat');
                            catch
                                pth=strcat(tmps,'\',obj.algo,'.mat');
                            end
                        end
                        
                        % flag for propagate the path existence
                        fld=exist(pth);
                        
                        % create folder
                        if ~exist(tmps)
                            mkdir(tmps);
                        end
                        
                    catch
                        warning('Problem in Code:manageIterfaceIn_ for operation.');
                    end
                else
                    
                    %It's a pipe
                    
                      pth=obj.findBench.curentPath;
                      if ~strcmp(extractBefore(fliplr(pth),'\'),fliplr(obj.algo))
                      pth=extractBefore(pth,strcat('\',obj.algo));
                    
                        
                        if isempty(pth)
                            pth=obj.findBench.curentPath;
                        end
                        
                        pth=strcat(pth,'\',obj.algo);
                        obj.findBench.setCurentPath(pth);
                        
%                         %
%                         try
%                             pth_=strcat(pth,'\',obj.interfaceIn.getFileName,'.mat');
%                         catch
%                             try
%                                 pth_=strcat(pth,'\',obj.interfaceIn.name,'.mat');
%                             catch
%                                 pth_=strcat(pth,'\',obj.algo,'.mat');
%                             end
%                         end
                        
                        % flag for propagate the path existence
                        %fld=exist(pth);
                        fld=0;
                    end
                    
                end
                
            catch
                warning('Problem in Code:manageIterfaceIn_.');
            end
        end
        
        %%
        function output = process_(obj)
            
            tStart = tic;
            
            % formatting the stucture of param
            try
                fieldNameBenchParam=fieldnames(obj.findBench.param);
                
                for fldn=fieldNameBenchParam'
                    obj.param = setfield(obj.param,char(fldn),eval(strcat('obj.findBench.param','.',char(fldn))));
                end
            catch
                fieldNameBenchParam='';
            end
            
            % execute process and set the output interface
            try
                
                %%In fonction of a structure of interface for send a
                %%standart interface
                tmp=obj.execProcess_;
                
                if isstruct(tmp)
                    obj.setInterfaceOut(tmp); %tmp is a structure
                else
                    try
                        if strcmp('InterfaceListObject', tmp.kind)
                            obj.setInterfaceOut(tmp); %tmp is an InterfaceListObject
                        else
                            obj.setInterfaceOut(InterfaceObject(obj.name,tmp)); %tmp is an InterfaceObject
                        end
                    catch
                        obj.setInterfaceOut(tmp); %tmp is other kind of interface
                    end
                end
                
                output = toc(tStart);
                
            catch
                try
                    warning('Problem in Code:process_ : Operation or Pipe --> %s.', obj.algo);
                catch
                    warning('Problem in Code:process_.')
                end
            end
        end
        
        %%
        function output = execProcess_(obj)
            
            try
                try
                    try
                        try
                            try
                                try
                                    try
                                        try
                                            output=feval(obj.algo,obj.interfaceIn.listObject.object,obj.param,obj.owner);
                                        catch
                                            output=feval(obj.algo,obj.interfaceIn.listObject,obj.param,obj.owner);
                                        end
                                    catch
                                        output=feval(obj.algo,obj.interfaceIn.object,obj.param,obj.owner);
                                    end
                                catch
                                    output=feval(obj.algo,obj.interfaceIn,obj.param,obj.owner);
                                end
                            catch
                                output=feval(obj.algo,obj.interfaceIn.listObject.object,obj.param);
                            end
                        catch
                            output=feval(obj.algo,obj.interfaceIn.listObject,obj.param);
                        end
                    catch
                        output=feval(obj.algo,obj.interfaceIn.object,obj.param);
                    end
                catch
                    output=feval(obj.algo,obj.interfaceIn,obj.param);
                end
                
                try
                    output=output.object;
                catch
                end
            catch
                try
                    warning('Problem in Code:execProcess_ : Operation or Pipe --> %s.', obj.algo);
                catch
                    warning('Problem in Code:execProcess_.')
                end
            end
            
        end
        
        %%
        function output = manageIterfaceOut_(obj, tElapsed,fld, pth)
            try
                if ~strcmp(obj.algo,obj.owner.name)
                    
                    tmp= obj.interfaceOut;
                    
                    if ~fld
                        
                        % save
                        try
                            
                            tmp=struct('time',tElapsed,'interface',tmp);
                            save (pth,'tmp','-v7.3');
                            obj.setInterfaceOut(tmp.interface);
                            tElapsed=tmp.time;
                        catch
                            warning('Problem in Code:manageIterfaceOut_:saving.');
                        end
                        
                    else
                        
                        % load
                        try
                           
                            load(pth);
                            obj.setInterfaceOut(tmp.interface);
                            tElapsed=tmp.time;
                            
                        catch
                            warning('Problem in Code:manageIterfaceOut_:loading.');
                        end
                    end
                else
                    
                    %prise en charge de l'enregistrement des fichies types pipes dans la BD 
                end
                
                output=tElapsed;
                
            catch
                warning('Problem in Code:manageIterfaceOut_.');
            end
        end
    end
end
