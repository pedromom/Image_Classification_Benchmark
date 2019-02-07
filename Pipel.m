classdef Pipel < BenchObjectRunnable & handle
    
    %%
    properties (SetAccess = protected)
        
     %   pptimes=struct('Time',0,'crntTime',0);
        nb_iter=0;
        nb_iter_total=0;
   
    end
   
    properties (SetAccess = protected, GetAccess = protected)
        lstOperation={};
        lstPipes={};
        interfaceTypeOutput;
        bnchTime;
    end
    
    %%
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Pipel(name,intefaceType, owner, prm)
            %PIPE Construct an instance of this class
            %   Detailed explanation goes here
            
            try
                % init pipe parameters
                obj.name=name;
                obj.interfaceIn=InterfaceImage('StartInterface',[]);
                obj.interfaceTypeOutput=intefaceType;
                obj.kind=intefaceType;
                obj.nb_iter=0;
                obj.nb_iter_total=0;
                obj.owner=owner;
                obj.bnchTime=tic;
                obj.param=prm;
                obj.type='pipe';
                try
                obj.curentDB=owner.curentDB;
                catch
                end
                
                % URI (Uniform Resource Identifier) construction
                URI='';
                
                % extract elements of parameters for to construct URI
                
                try
                
                for k=fieldnames(obj.param)'
                  
                    %ignore the name parameter 
                    %if ~(strcmp(k,'name'))&& ~(strcmp(k,'szDB')) && ~(strcmp(k,'szTDB'))
                    if ~(strcmp(k,'name')) %)&& ~(strcmp(k,'szDB')) && ~(strcmp(k,'szTDB'))
                        try
                            URI = strcat(URI,k,num2str(eval(char(strcat('obj.param.',k)))));
                        catch
                            URI = strcat(URI,k,eval(char(strcat('obj.param.',k))));
                        end
                    end
                end
                catch
                    URI=name;
                end
                
                
                if ~isempty(owner)
                    %if isn't the bench
                    if isempty(URI)
                        %initialisation of URI
                        URI=char(obj.owner.URI);
                    else
                        %complete URI
                        URI=strcat(URI,'\',char(obj.owner.URI));
                    end
                else
                    %if is the bench 
                    URI=strcat('\',URI);
                end
                
                obj.URI=URI;
                
            catch
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%
        function obj = addCode(obj,algo,name,prm)
            obj.addOperation(name,algo,prm);
        end
        
        %%
%         function obj = addDisplay(obj,algo,name,prm)
%             obj.addOperation(name,algo,prm);
%         end
        
        %%
        function obj = addOperation(obj,name,algo,prm)
 
            try
                
                if ~obj.isExistOperation_(name)
                 
                    %if the operation don't existe --> create
                    obj.lstOperation(end+1)={Code(name,'Interface_Value',algo,prm,obj)};
                    op=obj.lstOperation(end);
                    op=op{1};
                    
                else
                    
                    %The first cell in the list is always the pipeline.
                    %We compare the operation's name with pipeline's name.
                    if ~strcmp(obj.getLstOperations{1}.name,name)
                        op=obj.getOperation(name);
                        op.param=prm;
                    else
                        %An operation can not have the name of its pipeline.
                     %   warning('Pipe:addOperation','This name exists as a pipeline name !!!');
                    end
                    
                end
                
            catch
            end
        end
        
        %%
        function obj = setInterface(obj,kind,name)
            
            try
                
                if length(obj.interfaceOut)==0
                    obj.interfaceOut=feval(kind,name);
                end
                
            catch    
            end
            
        end
        
        %%
        function [output] = runOp(obj, nameOpertaion, previousOperation)
            
            try
                try
                    int = obj.manageInterfaceOp_(previousOperation );
                catch
                    int = obj.manageInterfaceOp_();
                end
                
                op = obj.processOp_(int, nameOpertaion);
                
                output= op.interfaceOut;
                
                try
                    output=output.object;
                catch
                end
                
            catch
            end
            
        end
        
        %%
        function [output] = runPipe(obj, nameOpertaion, previousOperation)
            try
                
                output=InterfaceListObject(nameOpertaion);
                
                if ~(obj.isExistOperationOnLstPipes_(nameOpertaion))
                    warning('Bench:runPipe','This operation not exist for this pipe !!!');
                else
                    
                    try
                        int_ = obj.manageInterfacePipe_(previousOperation );
                    catch
                        int_ = obj.manageInterfacePipe_();
                    end
                    
                    pp=obj.initPipe_(int_,nameOpertaion);
                    
                    output=obj.processPipe_(int_,nameOpertaion,pp, output);
 
                end
                
            catch
            end
            
        end

        %%
        function output = addAPipe(obj,algo,name,prm)
 
            obj.addPipe(algo,'Interface_Value',prm);
            output=obj.getPipe(algo);
            output=output{1}.addCode(algo,name,prm);
 
        end
        
        %%
        function obj = addPipe(obj,name,intefaceType,prm)

            try
                
                if ~obj.isExistPipe_(name)
                    obj.lstPipes(end+1)={Pipel(name,intefaceType,obj,prm)};
                else
                    disp('****');
                end
                
            catch
            end
            
        end
        
        %%
       
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%
        function output = getLstOperations(obj)
            % returns the list of operations contained in a pipe
            % getLstOperations{1} is always an operation of pipe
            output = obj.lstOperation;
        end
        
        %%
        function output = getOperation(obj, name)
            % returns a particular operation
            % name = name of operation than we are looking for
            [k,output]=obj.getIdexOperation_(name);
        end
        
%         %%
%         function output = getNbIterTotal(obj)            
%             output = obj.nb_iter_total;
%         end
%         
        %%
        function output = getLstPipes(obj)
            % returns the list of pipe contained in a pipe
            output = obj.lstPipes;
        end
        
        %%
        function output = getPipe(obj, name)
      
            output=obj.lstPipes(obj.getIdexPipe_(name));
        end
        
        %%
        function output = getIdexPipe_(obj, name)
      
            output = obj.isExistPipe_(name);
        end
        
        %%
        function output = getOperationOfLstPipes(obj, nameOpertaion)
            
            output=[];
            
            for pp=obj.getLstPipes
                for ppop=pp{1}.getLstOperations
                    if strcmp(ppop{1}.name,nameOpertaion)
                        output=ppop{1};
                        break;
                    end
                end
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
    methods ( Access = protected )
        
        
        function [index,oper] = getIdexOperation_(obj, name)
            
            lst=obj.getLstOperations();
            index=0;
            for op=lst
                if strcmp(op{1}.name,name)
                    index=obj.isExistOperation_(name);
                    oper=op{1};
                    break;
                end
            end
            
            if ~index
                throw(MException('Pipe:getIdexOperation_','Name OF OPERATION NOT exist !!!'))
            end
            
        end
        
        %%
        function output = isExistOperation_(obj, name)
            
            lst=obj.getLstOperations();
            output=false;
            
            k=0;
            
            for pp=lst
                k=k+1;
                if strcmp(pp{1}.name,name)
                    output=k;
                    break;
                end
            end
            
        end
        
        %%
        function output = isExistOperationOnLstPipes_(obj, nameOpertaion)
            
            output=false;
            
            for pp=obj.getLstPipes
                for ppop=pp{1}.getLstOperations
                    if strcmp(ppop{1}.name,nameOpertaion)
                        output=true;
                        break;
                    end
                end
            end
        end
        
        %%
        function output = isExistPipe_(obj, name)

            lst=obj.getLstPipes();
            output=false;
            
            k=0;
            
            for pp=lst
                k=k+1;
                if strcmp(pp{1}.name,name)
                    output=k;
                    break;
                end
            end
            
        end
        
        %%
        function output = manageInterfaceOp_(obj, previousOperation )
            
            if ~exist('previousOperation', 'var')
                int=obj.interfaceIn;
                try
                    int.formatIn;
                catch
                end
                
            else
                try
                    try
                    opp=obj.getOperation(previousOperation);
                    int=opp.interfaceOut;
                    catch
                        int=manageInterfaceOp_(obj.getLstPipes{1}.getLstOperations{1},previousOperation);
                    end
                catch
                    int=previousOperation;
                end
            end
            
            output=int;
        end
        
        %%
        function output = processOp_(obj, int, nameOpertaion)
            try
                op= obj.getOperation(nameOpertaion);
                op.setInterfaceIn(int);
                tStartPipe = tic;
                
                % run the operation
                op.run;
                
                tElapsed = toc(tStartPipe);
                obj.setTime(tElapsed);
                
%                 try
%                     %obj is the bench
%                     obj.updateTime(tElapsed);
%                 catch
%                     %obj is pipe or oprartion
%                     obj.owner.updateTime(tElapsed);
%                 end
%                 
                output=op;
            catch
            end
        end
        
        %%
        function output = manageInterfacePipe_(obj, previousOperation )
            
            if ~exist('previousOperation', 'var') 
                try
                    %if the interface 'in' is an imds
                    output=obj.interfaceIn.Labels;
                    output=obj.interfaceIn.Files';
                catch
                    output=obj.interfaceIn;
                end
            else
                try
                    try
                        % if previousOperation is an operation
                        opp=obj.owner.getOperationOfLstPipes(previousOperation);
                        output=opp.getInterfaceOut;
                    catch
                        % if previousOperation is a pipe
                        opp=obj.getOperationOfLstPipes(previousOperation);
                        output=opp.getInterfaceOut;
                    end
                catch
                    try
                        %if the interface is an imds
                        output=previousOperation.Labels;
                        output=previousOperation.Files';
                    catch
                        output=previousOperation;
                    end
                end
            end
        end
        
        %%
        function pp = initPipe_(obj,int,nameOpertaion)
            
            pp=obj.getOperationOfLstPipes(nameOpertaion).owner;
            pp.nb_iter=0;
            pp.nb_iter_total=length(int);
            
        end
        
        %%
        function output = processPipe_(obj, int_,nameOpertaion,pp,rsp)
            
            try
                
                try
                    if length(int_)==1
                        % extract a standardised interface
                        int_=int_.getObject;
                    end
                catch
                end
                
                % run a list of interfaces
                for int=int_
                    
                    if iscell(int)
                        int=int{1};
                    end
                    
                    try
                        int=int.object;
                    catch
                    end
                    
                    %                     obj.addDisplay('toolsDisplayTime_A','DISPTM',struct('name', 'DISPTM',...
                    %                         'Source',obj.name,...
                    %                         'TotalTime', pp.times.crntTime,...
                    %                         'Nb_IterTotal', pp.nb_iter_total,...
                    %                         'Nb_iterations', pp.nb_iter));
                    
                    %reset the path
                    try
                    obj.findBench.setCurentPath(strcat(obj.URI,int.addAtURI));
                    catch
                    end
                    
                    pp.interfaceIn=int;
                    pp.nb_iter=pp.nb_iter+1;
                    op= pp.getOperation(nameOpertaion);
                    op.setInterfaceIn(int);
                    tStartPipe = tic;
                    
                    %run an operation for an interface
                    op.run;
                    
                    tElapsed = toc(tStartPipe);
                    pp.times=[obj.times, tElapsed];
                   % pp.updateTime(tElapsed);
                    
                    % accumulation of operations results
                    rsp.addObject(op);
                    
                end %for
                
                output=rsp;
            catch
            end
        end
        
    end
end

