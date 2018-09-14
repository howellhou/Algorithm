#include <iostream>
#include <algorithm>
using namespace std;

struct Polynomial
{
    long long capacity;
    long long degree;
    long long* coeff;
    Polynomial(long long n)
    {
        capacity = n;
        degree = 0;
        coeff = new long long[n];
        for (long long i=0; i<n ;i++) coeff[i] = 0;
    }

    void print()
    {
        for (long long i=0; i<capacity; i++) cout<<coeff[i]<<' ';
        cout<<endl;
    }
};

Polynomial* MUL(Polynomial* P, Polynomial* Q)
{
    long long n = max(P->capacity,Q->capacity);
    if (n == 1)
    {
        Polynomial* result = new Polynomial{2};
        result->coeff[0] = P->coeff[0]*Q->coeff[0];
        return result;
    }
    Polynomial *PL = new Polynomial{n/2};
    Polynomial *PR = new Polynomial{n/2};
    Polynomial *QL = new Polynomial{n/2};
    Polynomial *QR = new Polynomial{n/2};

    for (long long i=0; i<n/2; i++) PR->coeff[i] = P->coeff[i];
    for (long long i=0; i<n/2; i++) PL->coeff[i] = P->coeff[i+n/2];
    for (long long i=0; i<n/2; i++) QR->coeff[i] = Q->coeff[i];
    for (long long i=0; i<n/2; i++) QL->coeff[i] = Q->coeff[i+n/2];

    Polynomial* MLL = MUL(PL,QL);
    Polynomial* MRR = MUL(PR,QR);
    for (long long i=0; i<n/2; i++) PL->coeff[i] += PR->coeff[i];
    for (long long i=0; i<n/2; i++) QL->coeff[i] += QR->coeff[i];
    Polynomial* MSUM = MUL(PL,QL);

    Polynomial* result = new Polynomial{2*n};
    for (long long i=0; i<n; i++) result->coeff[i+n] += MLL->coeff[i];
    for (long long i=0; i<n; i++) result->coeff[i+n/2] = result->coeff[i+n/2] + MSUM->coeff[i] - MLL->coeff[i] - MRR->coeff[i];
    for (long long i=0; i<n; i++) result->coeff[i] += MRR->coeff[i];

    delete PL;
    delete PR;
    delete QL;
    delete QR;
    delete MLL;
    delete MRR;
    delete MSUM;

    return result;
}

int main()
{
    long long m,n,A,temp,pow;
    cin >> n >> m >> A;

    pow = 1;
    while (pow<=n) pow*=2;
    Polynomial* P = new Polynomial{pow};

    pow = 1;
    while (pow<=m) pow*=2;
    Polynomial* Q = new Polynomial{pow};

    for (long long i=0; i<=n; i++)
    {
        cin >> temp;
        if (temp != 0)
        {
            P->degree = i;
            P->coeff[i] = temp;
        }
    }
    for (long long i=0; i<=m; i++)
    {
        cin >> temp;
        if (temp != 0)
        {
            Q->degree = i;
            Q->coeff[i] = temp;
        }
    }

    for (long long i=0; i<=Q->degree; i++) Q->coeff[i] *= A;
    if (A == 0) Q->degree = 0;

    if (2*P->degree != Q->degree) {
        cout << "FALSE";
        delete P;
        delete Q;
        return 0;
    }

    Polynomial* result = MUL(P,P);

    for (long long i=0; i<= Q->degree; i++)
    {
        if (Q->coeff[i] != result->coeff[i])
        {
            cout << "FALSE";
            delete P;
            delete Q;
            delete result;
            return 0;
        }
    }
    delete P;
    delete Q;
    delete result;
    cout << "TRUE";
    //P->print();
    //Q->print();
}
