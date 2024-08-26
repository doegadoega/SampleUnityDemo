using System.Threading;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cube : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        this.Sent("Hello World");
    }

    // Update is called once per frame
    void Update()
    {
        this.Sent("unko_sine");
    }

    public void Sent(string message) {
        Debug.Log("Sent message -> " + message);
    }
}
