%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function dx = sampson_err(u,H)
dx = fHDs(inv(H),u);

%N = size(u,2);
%A = zeros(9,2*N); 
%
%A(:,1:2:end) = [  zeros(3,N); ...
%                 -u(1:3,:); ...
%                  u([5 5 5],:).*u(1:3,:)];
%
%A(:,2:2:end) = [  u(1:3,:); ...
%                  zeros(3,N); ...
%                 -u([4 4 4],:).*u(1:3,:) ];
%
%Ht = H';
%h = Ht(:);
%e = reshape(h'*A,2,N);
%
%ttt = h(7)*u(1,:)+h(8)*u(2,:)+h(9);
%
%df_dx1 = [h(7)*u(5,:)-h(4) h(1)-h(7)*u(4,:)];
%df_dy1 = [h(8)*u(5,:)-h(5) h(2)-h(8)*u(4,:)];
%df_dx2 = [zeros(1,N) -ttt];
%df_dy2 = [ttt zeros(1,N)];
%
%J1t = [df_dx1(1:N); ...
%       df_dy1(1:N); ...
%       df_dx2(1:N); ...
%       df_dy2(1:N)];
%
%J2t = [df_dx1((N+1):end); ...
%       df_dy1((N+1):end); ...
%       df_dx2((N+1):end); ...
%       df_dy2((N+1):end)];
%
%j2j2 = dot(J2t,J2t);
%j2j1 = dot(J2t,J1t);
%j1j1 = dot(J1t,J1t);
%
%iJJ = [ j2j2; ...
%       -j2j1; ...
%       -j2j1; ...
%        j1j1 ];
%
%D = repmat(1./(iJJ(4,:).*iJJ(1,:)-iJJ(3,:).*iJJ(2,:)),4,1);
%id = D(1,:) < 1e8;
%
%iJJ(:,id) = iJJ(:,id).*D(:,id);
%
%for k = find(~id)
%    ijj = pinv([j1j1(k) j2j1([k k]) j2j2(k)]);
%    iJJ(:,k) = ijj(:);
%end
%
%tmp = [dot(iJJ([1 3],:),e); ...
%       dot(iJJ([2 4],:),e)];
%
%dxt = -[dot([J1t(1,:) J1t(2,:) J1t(3,:) J1t(4,:); ...
%             J2t(1,:) J2t(2,:) J2t(3,:) J2t(4,:)], ...
%            repmat(tmp,1,4))];
%
%dx = [ dxt(1:N); ...
%       dxt(N+1:2*N); ...
%       dxt(2*N+1:3*N); ...
%       dxt(3*N+1:4*N) ];