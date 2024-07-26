clc; clear; close all; %실행 전 파일 정리

%%프로그램 및 파일 위치 확인
spicePath = "C:\Users\Design And Control\AppData\Local\Programs\ADI\LTspice\LTspice.exe"; %LTspice 실행 파일 위치
filePath = "C:\Users\Design And Control\DNC\LTspice2MATLAB_ver_2"; %MATLAB 작업 공간 위치
netPath = "C:\\Users\\Design And Control\\DNC\\LTspice2MATLAB_ver_2"; %넷리스트 위치

%%시뮬레이션 정보 설정
fileName = 'example'; %시뮬레이션 파일 (.asc) 이름
Res = 10e3; %저항의 값
Cap = 160e-12; %커패시터의 값
Vmax = 1; %입력 전압 최댓값
f = 60; %주파수
endtime =0.1; %시뮬레이션 종료 시간
analysistype = 'tran'; %시뮬레이션 방식

%%시뮬레이션 및 넷리스트 생성
pathString = sprintf('* %s%s.asc',netPath, fileName); %시뮬레이션 설정
%회로 구성요소 설정
components(1) = makeComponent('R1', 'Vo', 'Vi', '{R}');
components(2) = makeComponent('C1', 'Vo', '0', '{C}');
components(3) = makeComponent('V1', 'Vi', '0', 'SINE(0 {ampl} {freq}');
for i = 1:length(components)
components(i).string = sprintf('%s %s %s %s', components(i).name,components(i).startNode,components(i).endNode,components(i).type);
end
compString = components(1).string;
for i = 2:length(components)
    compString = sprintf('%s\r\n%s',compString,components(i).string);
end

% 파라미터 작성
paramString = sprintf('.params R = %d C = %d ampl = %d freq = %d', Res, Cap, Vmax, f);
% 시뮬레이션 방식 작성
analysisString = sprintf('.%s %s', analysistype, endtime);

% 넷리스트 종료 작성
endString = sprintf('.backanno\r\n.end\r\n');

% 넷리스트 생성
netList = sprintf('%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n',pathString,compString,paramString,analysisString,endString); 
netName = sprintf('%s.net',fileName);
fileID = fopen(netName,'w');
fprintf(fileID,netList);
fclose('all');
% Run the simulation
result = simulateModel(spicePath, fileName, filePath);

