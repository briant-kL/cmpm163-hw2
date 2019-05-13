using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scene_manage : MonoBehaviour
{
    public int index = 0;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("space"))
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene(index);
        }
    }
}
