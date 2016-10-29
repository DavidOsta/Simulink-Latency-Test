% helper script to merge two timeseries

long1 = load('measured_data/24-long-1/measured_data');
long2 = load('measured_data/24-long-2/measured_data');

cut2 = 100001;

ref2Time = long2.data_struct.delay_ref.Time(1:cut2);
ref2Data = long2.data_struct.delay_ref.Data(1:cut2);
ref2Ts = timeseries(ref2Data, ref2Time);

del2Time = long2.data_struct.delay_B.Time(1:cut2);
del2Data = long2.data_struct.delay_B.Data(1:cut2);
del2Ts = timeseries(del2Data, del2Time);



% adjust data 1
data1_del = long1.data_struct.delay_B;
data1_ref = long1.data_struct.delay_ref;

cut1 = 100001;
ref1Time = long1.data_struct.delay_ref.Time(2:end) + 100;
ref1Data = long1.data_struct.delay_ref.Data(2:end);
ref1Ts = timeseries(ref1Data, ref1Time);

del1Time = long1.data_struct.delay_B.Time(2:end) + 100;
del1Data = long1.data_struct.delay_B.Data(2:end);
del1Ts = timeseries(del1Data, del1Time);


% merging samples
refTimeMerged = [ref2Time; ref1Time];
refDataMerged = [ref2Data; ref1Data];
refMergedTS = timeseries(refDataMerged, refTimeMerged);

delTimeMerged = [del2Time; del1Time];
delDataMerged = [del2Data; del1Data];
delMergedTS = timeseries(delDataMerged, delTimeMerged);

figure
plot(refMergedTS);hold on ; plot(delMergedTS)


% new struct
data_struct = struct('delay_B',delMergedTS,...
                    'delay_ref',refMergedTS,...
                    'response_B',[]);

