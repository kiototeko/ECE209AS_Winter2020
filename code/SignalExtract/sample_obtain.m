function samp = sample_obtain(S,d,T,inst)

chunks = [];
G = (S - d : S + d);
c_len = int32(median(G));

for i = 1:length(inst)
    if length(inst) < max(G)*2
        samp = [];
        return
    end
    inds = [];
    for j = G
        r = Pcorr(inst(1:j), inst(j + 1: j + c_len));
        inds = [inds r(2)];
    end
    [~,idx] = max(inds);
    j = G(idx);
    r = Pcorr(inst(1:j), inst(j + 1:j*2));
    
    if(r(2) > T)
        chunks = inst(1:j);
        inst = inst(j+1:length(inst));
        break;
    else
        inst = inst(2:length(inst));
    end
end

next_len = G;
state = 1;
sync_count = 0;
corrs = [];
cc = chunks;


while(length(inst) > c_len + max(next_len))
    inds = [];
    for j=next_len
        
        r = Pcorr(cc, inst(j+1:j + c_len));
        inds = [inds r(2)];
    end
    [~,idx] = max(inds);
    j = next_len(idx);
    
    c = Pcorr(cc, inst(j+1:j + c_len));
    r = Pcorr(cc, inst(1:j));

    if r(2) > T && state == 1
        chunks = [chunks;inst(1:length(cc))];
        corrs = [corrs r(2)];
        chunks_lenth = size(chunks);
    
    else
        if c(2) < T
            state = 2;
            next_len = (S: S + 3000);
            sync_count = sync_count + 1;
            
        else
            state = 1;
            next_len = G;
        end
   end
   inst = inst(j+1:length(inst));
end

samp = chunks;