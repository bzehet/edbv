function varargout = guiOutput(varargin)
% GUIOUTPUT MATLAB code for guiOutput.fig
%      GUIOUTPUT, by itself, creates a new GUIOUTPUT or raises the existing
%      singleton*.
%
%      H = GUIOUTPUT returns the handle to a new GUIOUTPUT or the handle to
%      the existing singleton*.
%
%      GUIOUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIOUTPUT.M with the given input arguments.
%
%      GUIOUTPUT('Property','Value',...) creates a new GUIOUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiOutput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiOutput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiOutput

% Last Modified by GUIDE v2.5 28-Dec-2017 10:31:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiOutput_OpeningFcn, ...
                   'gui_OutputFcn',  @guiOutput_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiOutput is made visible.
function guiOutput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiOutput (see VARARGIN)

% Choose default command line output for guiOutput
handles.output = hObject;

axes(handles.axesInput);
imshow(varargin{1});
axes(handles.axesOtsu);
imshow(varargin{2});
axes(handles.axesCleaning);
imshow(varargin{3});
axes(handles.axesTransformation);
imshow(varargin{4});
axes(handles.axesLabeling);
imshow(varargin{5});
set(handles.textSolFormula, 'String', varargin{8});
set(handles.textSolResult, 'String', varargin{9});
set(handles.textFormula, 'String', varargin{6});
set(handles.textResult, 'String', varargin{7});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiOutput wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiOutput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
