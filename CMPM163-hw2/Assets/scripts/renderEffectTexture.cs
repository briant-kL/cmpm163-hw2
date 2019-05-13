using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class renderEffectTexture : MonoBehaviour
{
    private Material screemMat;
    public Shader BloomShader;


    [Range(0.0f, 100.0f)]
    public float BloomEffect = 50.0f;

    // Start is called before the first frame update
    void Start()
    {
        if(screemMat == null)
        {
            screemMat = new Material(BloomShader);
            screemMat.hideFlags = HideFlags.HideAndDontSave;
        }
        BloomEffect = 25f;


    }

    /*
    private void CreateBuffers()
    {
        tempTexture1 = new RenderTexture(Screen.width, Screen.height, 0);
        //rtID = new RenderTargeIdentifier(tempTexture1);
    }
    */

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        RenderTexture brightTexture = RenderTexture.GetTemporary(source.width, source.height);
        RenderTexture blurTexture = RenderTexture.GetTemporary(source.width, source.height);

        Graphics.Blit(source, brightTexture, screemMat, 0);
        screemMat.SetFloat("_Steps", BloomEffect);
        Graphics.Blit(brightTexture, blurTexture, screemMat, 1);
        screemMat.SetTexture("_BaseTex", source);
        Graphics.Blit(blurTexture, destination, screemMat, 2);

        RenderTexture.ReleaseTemporary(brightTexture);
        RenderTexture.ReleaseTemporary(blurTexture);


        /*
         Graphics.Blit(source, solid, screemMat, 0);
        screemMat.SetFloat("_Steps", BloomEffect);
        Graphics.Blit(solid, outlineBlur, screemMat, 1);
        screemMat.SetTexture("_BaseTex", source);
        Graphics.Blit(outlineBlur, destination, screemMat, 2);
        RenderTexture.ReleaseTemporary(solid);
        RenderTexture.ReleaseTemporary(outlineBlur);

        Graphics.Blit(source, destination);
         */



    }

    void OnDisable()
    {
        if (screemMat)
        {
            DestroyImmediate(screemMat);
        }
    }



}
