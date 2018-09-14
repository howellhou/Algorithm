#include <iostream>
using namespace std;

long min(long a, long b)
{
    return a<b?a:b;
}

long n;
long* A,*B,*P,*M;

long index(long a,long b,long c) {
    return a*2*(n+1) + b*2 + c;
}

void printRace(long i, long j, int last)
{
    if (i==0) return;

    if (last == 0)
    {
        if (M[index(i,j,0)] == M[index(i-1,j,1)] + B[i-1] + P[i-1])
            printRace(i-1,j,1);
        else
            printRace(i-1,j,0);
        cout<<'B';
    }
    else
    {
        if (M[index(i,j,1)] == M[index(i-1,j-1,0)] + A[i-1] + P[i-1])
            printRace(i-1,j-1,0);
        else
            printRace(i-1,j-1,1);
        cout<<'A';
    }
}

int main()
{
    cin >> n;
    A = new long [n];
    B = new long [n];
    P = new long [n];
    for (long i=0; i<n; i++)
    {
        cin >> A[i];
    }
    for (long i=0; i<n; i++)
    {
        cin >> B[i];
    }
    P[0] = 0;
    for (long i=1; i<n; i++)
    {
        cin >> P[i];
    }
    M = new long [(n+1)*(n+1)*2];
    M[index(0,0,0)] = 0;
    M[index(0,0,1)] = 0;
    M[index(1,0,0)] = B[0];
    M[index(1,1,1)] = A[0];
    for (long i=1; i<=n; i++)
    {
        for (long j=0; j<=i; j++)
        {   //This is run by B
            if (j!=i)
            {
                if (M[index(i-1,j,1)] != -1)
                {
                   M[index(i,j,0)] = M[index(i-1,j,1)] + B[i-1] + P[i-1];
                   if (M[index(i-1,j,0)] != -1)
                        M[index(i,j,0)] = min(M[index(i,j,0)],M[index(i-1,j,0)] + B[i-1]);

                }
                else
                    M[index(i,j,0)] = M[index(i-1,j,0)]+ B[i-1];
            }
            else
                M[index(i,j,0)] = -1;
            //This is run by A
            if (j!=0)
            {
                if (M[index(i-1,j-1,0)] != -1)
                {
                    M[index(i,j,1)] = M[index(i-1,j-1,0)] + A[i-1] + P[i-1];
                    if (M[index(i-1,j-1,1)]!=-1)
                        M[index(i,j,1)] = min(M[index(i,j,1)],M[index(i-1,j-1,1)]+A[i-1]);
                }
                else
                    M[index(i,j,1)] = M[index(i-1,j-1,1)]+A[i-1];
            }
            else
                M[index(i,j,1)] = -1;
        }
    }

    if (M[index(n,n/2,0)] < M[index(n,n/2,1)])
    {
        cout<<M[index(n,n/2,0)]<<endl;
        printRace(n,n/2,0);
    }
    else
    {
        cout<<M[index(n,n/2,1)]<<endl;
        printRace(n,n/2,1);
    }

}
