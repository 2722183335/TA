using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Light))]
public class TAPointLight : MonoBehaviour
{
    private Light _light;
    //private ITA_Point ta_point;
    // private void Start()
    // {
    //     
    //    
    // }
    private void OnDrawGizmos()
    {
        PreCull();
    }

    private void PreCull()
    {
        if (_light==null)
        {
            _light = GetComponent<Light>();
        }
        if (_light.type == LightType.Point) 
        {
            Vector4 _pointLightColorAndRange=(Vector4)(_light.color * _light.intensity);
            _pointLightColorAndRange.w = _light.range;
            Shader.SetGlobalVector("_PointLightColorAndRange", _pointLightColorAndRange);
            Shader.SetGlobalVector("_PointLightPos",(Vector4)transform.position);
        }
    }
}
//public interface ITA_Point
//{
//    public void RefLight();
//}

//public class TA_Point_Light: ITA_Point
//{ }
//public class TA_Spot_Light : ITA_Point
//{ }
//public class TA_
//{ }
