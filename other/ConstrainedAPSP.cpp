#include<iostream>
#include<string>
#include<cstring>
#include<sstream>
#include<vector>
#include<bits/stdc++.h>
using namespace std;

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
    long n,q;
    string in;
    cin>>n>>q;
    getline(cin,in);
    getline(cin,in);
    stringstream ss{in};
    long k=0;
    long temp;
    vector<long> S;
    while (ss>>temp) {
        k++;
        S.push_back(temp);
    }
    long w[n][n];
    for (long i=0;i<n;i++) {
        for (long j=0;j<n;j++) {
            cin>>w[i][j];
        }
    }
    long dis[n][n];

    for (long i=0; i<k; i++) {
        long x = S[i] - 1;
        for (long j=0; j<n; j++) dis[x][j]=-1;
        dis[x][x] = 0;
        vector<pair<long,long>> H;
        H.push_back(pair<long,long>{x,0});
        for (long j=0; j<n; j++)
            if (j!=x) H.push_back(pair<long,long>{j,-1});
        while (H.size()!=0) {
            long u = H[0].first;
            H.erase(H.begin());
            for (long v=0; v<n; v++){
                if (w[u][v]>=0 && (dis[x][u]+w[u][v]<dis[x][v] || dis[x][v]==-1)) {
                    dis[x][v] = dis[x][u]+w[u][v];
                    long indexV = 0;
                    while (H[indexV].first!=v) indexV++;
                    H[indexV].second = dis[x][v];
                    while (indexV>0 && H[indexV].second<H[indexV-1].second) {
                        swap(H[indexV-1],H[indexV]);
                        /*
                        long tmp;
                        tmp = H[indexV-1].first;
                        H[indexV-1].first  = H[indexV].first;
                        H[indexV].first = tmp;
                        tmp = H[indexV-1].second;
                        H[indexV-1].second  = H[indexV].second;
                        H[indexV].second = tmp;
                        */
                        indexV--;
                    }
                }
            }
        }
        /*
        cout<<"Dist starting from "<<x<<": ";
        for (long j=0; j<n; j++) cout<<dis[x][j]<<' ';
        cout<<endl;
        */
    }


    for (long i=0; i<k; i++) {
        long x = S[i] - 1;
        for (long j=0; j<n; j++) dis[j][x]=-1;
        dis[x][x] = 0;
        vector<pair<long,long>> H;
        H.push_back(pair<long,long>{x,0});
        for (long j=0; j<n; j++)
            if (j!=x) H.push_back(pair<long,long>{j,-1});
        while (H.size()!=0) {
            long u = H[0].first;
            H.erase(H.begin());
            for (long v=0; v<n; v++){
                if (w[v][u]>=0 && (dis[u][x]+w[v][u]<dis[v][x] || dis[v][x] == -1)) {
                    dis[v][x] = dis[u][x]+w[v][u];
                    long indexV = 0;
                    while (H[indexV].first!=v) indexV++;
                    H[indexV].second = dis[v][x];
                    while (indexV>0 && H[indexV].second<H[indexV-1].second) {
                        swap(H[indexV-1],H[indexV]);
                        /*
                        long tmp;
                        tmp = H[indexV-1].first;
                        H[indexV-1].first  = H[indexV].first;
                        H[indexV].first = tmp;
                        tmp = H[indexV-1].second;
                        H[indexV-1].second  = H[indexV].second;
                        H[indexV].second = tmp;
                        */
                        indexV--;
                    }
                }
            }
        }
    }

    long result[n][n]={0};
    memset(result, 0, sizeof(result[0][0]) * n * n);
    long Sresult[n][n];
	
    for (long t=0;t<q;t++) {
        long u,v;
        cin>>u>>v;
        u--;
        v--;
        if (result[u][v]==0) {
            result[u][v]=-1;
            Sresult[u][v]=-1;
            for (long i=0; i<k; i++){
                long x = S[i]-1;
                if (dis[u][x]>=0 && dis[x][v]>=0){
                    if (result[u][v]==-1) {
                        result[u][v] = dis[u][x] + dis[x][v];
                        Sresult[u][v] = x+1;
                    } else {
                        if (dis[u][x] + dis[x][v] < result[u][v]) Sresult[u][v]=x+1;
                        result[u][v] = min(result[u][v], dis[u][x] + dis[x][v]);
                    }
                }
            }
        }
        cout<<result[u][v]<<' '<<Sresult[u][v]<<'\n';
    }
	
}
